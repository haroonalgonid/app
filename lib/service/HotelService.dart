import 'dart:convert';
import 'package:http/http.dart' as http;

import 'TokenManager.dart';

class HotelService {
  static const String baseUrl = "https://backend-fpnx.onrender.com";

  // Get all hotels with specific fields
static Future<List<Map<String, dynamic>>?> getHotels() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/hotels'));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> hotelsData = responseData["hotels"] ?? [];

      return hotelsData.map<Map<String, dynamic>>((hotelEntry) {
        final hotel = hotelEntry["hotel"];
        return {
          "id": hotel["_id"],
          "name": hotel["name"],
          "type": hotel["type"],
          "address": hotel["address"],
          "logo": hotel["logo"],
          "phoneNumber": hotel["phoneNumber"],
          "website": hotel["website"],
          "email": hotel["email"],
          "facilities": List<String>.from(hotel["facilities"] ?? []),
          "images": List<String>.from(hotel["images"] ?? []),
          "commercialRecord": hotel["commercialRecord"],
          "license": hotel["license"],
          "averageRating": hotelEntry["averageRating"] ?? 0.0,
          "totalReviews": hotelEntry["totalReviews"] ?? 0,
          "__v": hotel["__v"]
        };
      }).toList();
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    print("Exception in getHotels: $e");
  }
  return null;
}

  static Future<bool> addHotelReview(
      String hotelId, int rating, String comment) async {
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
          "hotel": hotelId,
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
      print("Exception in addHotelReview: $e");
    }
    return false;
  }

  // Get hotel reviews and rating
  static Future<List<Map<String, dynamic>>?> getHotelReviews(
      String hotelId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/reviews/average?hotelId=$hotelId'),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        List<dynamic> reviewsData = data["reviewsData"] ?? [];

        return reviewsData.map<Map<String, dynamic>>((review) {
          return {
            "fullName": review["user"]["fullName"],
            "rating": review["rating"],
            "comment": review["comment"],
            "createdAt": review["createdAt"],
          };
        }).toList();
      } else {
        print(
            "Error fetching reviews: \${response.statusCode}, \${response.body}");
      }
    } catch (e) {
      print("Exception in getHotelReviews: \$e");
    }
    return null;
  }

  // Get rooms for a specific hotel
  static Future<List<Map<String, dynamic>>?> getHotelRooms(
      String hotelId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/hotels/$hotelId/rooms'));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> roomsData = responseData["rooms"] ?? [];

        return roomsData.map<Map<String, dynamic>>((room) {
          return {
            "id": room["_id"],
            "hotelName": room["hotel"]["name"],
            "hotelAddress": room["hotel"]["address"],
            "type": room["type"],
            "pricePerNight": room["pricePerNight"],
            "bedCount": room["bedCount"],
            "suiteRoomCount": room["suiteRoomCount"],
            "size": room["size"],
            "view": room["view"],
            "amenities": List<String>.from(room["amenities"] ?? []),
            "images": List<String>.from(room["images"] ?? []),
            "isAvailable": room["isAvailable"],
            "createdAt": room["createdAt"],
            "updatedAt": room["updatedAt"],
          };
        }).toList();
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Exception in getHotelRooms: $e");
    }
    return null;
  }

  // Book a room
  static Future<Map<String, dynamic>?> bookRoom(
      String roomId, String checkInDate, String checkOutDate) async {
    try {
      String? accessToken = await TokenManager.getAccessToken();
      if (accessToken == null) {
        print("Error: No access token found");
        return null;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/hotels/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          "room": roomId,
          "checkInDate": checkInDate,
          "checkOutDate": checkOutDate,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Exception in bookRoom: $e");
    }
    return null;
  }
}
