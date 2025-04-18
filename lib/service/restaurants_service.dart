import 'dart:convert';
import 'package:http/http.dart' as http;

import '../screens/Reataurants Screens/cartProvider.dart';
import '../screens/Reataurants Screens/restaurantDetail_screen.dart';
import '../screens/Reataurants Screens/restaurant_screen.dart';
import 'TokenManager.dart';

class RestaurantApi {
  static const String baseUrl = 'https://backend-fpnx.onrender.com';

 // دالة لجلب بيانات المطاعم
static Future<List<Restaurant>> fetchRestaurants() async {
  final url = Uri.parse('$baseUrl/restaurants');
  
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> restaurantsData = data['restaurants'] ?? [];
      
      // تعديل مسارات الصور هنا
      return restaurantsData.map((json) {
        // إضافة baseUrl لمسارات الصور إذا لم تكن موجودة
        if (json['logo'] != null && !json['logo'].startsWith('http')) {
          json['logo'] =  json['logo'];
        }
        
        if (json['images'] != null) {
          json['images'] = (json['images'] as List).map((image) {
            return image.startsWith('http') ? image :  image;
          }).toList();
        }
        
        return Restaurant.fromJson(json);
      }).toList();
    } else {
      throw Exception('Failed to load restaurants. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
// دالة لجلب قائمة الوجبات لمطعم معين
static Future<List<MenuItem>> fetchMenuItems(String restaurantId) async {
  final url = Uri.parse('$baseUrl/restaurants/$restaurantId/menuItems');
  try {
    final response = await http.get(url);

   if (response.statusCode == 200) {
  final decodedData = json.decode(response.body);
  print('Raw Data: $decodedData'); // طباعة البيانات الخام

  if (decodedData is Map && decodedData.containsKey('menuItems')) {
    final List<dynamic> menuItemsData = decodedData['menuItems'] ?? [];
    return menuItemsData
        .map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('Unexpected JSON format: Expected a Map with "menuItems" key but got ${decodedData.runtimeType}');
  }
} else {
  throw Exception('Failed to load menu items. Status Code: ${response.statusCode}');
}
  } catch (e) {
    throw Exception('Error: $e');
  }
}

 // دالة لجلب تقييمات المطاعم
  static Future<List<Review>> fetchRestaurantReviews(String restaurantId) async {
    final url = Uri.parse('$baseUrl/hospitals/reviews/average?restaurantId=$restaurantId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        if (decodedData is Map && decodedData.containsKey('reviewsData')) {
          final List<dynamic> reviewsData = decodedData['reviewsData'] ?? [];
          return reviewsData.map((review) => Review.fromJson(review)).toList();
        } else {
          throw Exception('Unexpected JSON format: Expected a Map with "reviewsData" key but got ${decodedData.runtimeType}');
        }
      } else {
        throw Exception('Failed to load restaurant reviews. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

 static Future<bool> addRestaurantReview(
    String restaurantId, int rating, String comment) async {
  try {
    String? accessToken = await TokenManager.getAccessToken();
    if (accessToken == null) {
      print("Error: No access token found");
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/hospitals/reviews'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "restaurant": restaurantId, // تم تغيير المفتاح من "hotel" إلى "restaurant"
        "rating": rating,
        "comment": comment,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Review added successfully");
      return true;
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    print("Exception in addRestaurantReview: $e");
  }
  return false;
}

// دالة لإرسال طلب وجبة جديد
static Future<bool> placeOrder(List<CartItem> cartItems) async {
  try {
    String? accessToken = await TokenManager.getAccessToken();
    if (accessToken == null) {
      print("Error: No access token found");
      return false;
    }
    
    // تحويل عناصر السلة إلى نموذج بيانات الطلب
    List<Map<String, dynamic>> orderItems = cartItems.map((item) => {
      "menuItem": item.menuItem.id,
      "quantity": item.quantity,
    }).toList();
    
    final response = await http.post(
      Uri.parse('$baseUrl/restaurants/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "menuItems": orderItems,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Order placed successfully");
      return true;
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
      return false;
    }
  } catch (e) {
    print("Exception in placeOrder: $e");
    return false;
  }
}

}