import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TokenManager.dart'; // Assuming TokenManager is in a separate file

class FlightService {
  static const String baseUrl = "https://backend-fpnx.onrender.com";

  static Future<List<Map<String, dynamic>>> fetchFlights() async {
    final response = await http.get(Uri.parse('$baseUrl/flights'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((flight) {
        return {
          "id": flight["_id"],
          "arrivalAirport": flight["arrivalAirport"],
          "priceEconomy": flight["priceEconomy"]
        };
      }).toList();
    } else {
      throw Exception('Failed to load flights: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> fetchFlightDetails(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/flights/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load flight details: ${response.body}');
    }
  }

static Future<Map<String, dynamic>> bookFlight(Map<String, dynamic> bookingData) async {
  String? accessToken = await TokenManager.getAccessToken();

  if (accessToken == null) {
    throw Exception('الرجاء تسجيل الدخول');
  }

  final response = await http.post(
    Uri.parse('$baseUrl/bookings'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(bookingData),
  );

  if (response.statusCode == 201) {
    return jsonDecode(response.body); // Return the response after booking
  } else if (response.statusCode == 401) {
    throw Exception('الرجاء تسجيل الدخول اولا');
  } else {
    throw Exception('حدث خطأ أثناء الحجز');
  }
}

    // دالة لجلب الرحلات المخفضة
  static Future<List<Map<String, dynamic>>> fetchDiscountedFlights() async {
    final response = await http.get(Uri.parse('$baseUrl/flights/discounted'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((flight) {
        return {
          "id": flight["_id"],
          "arrivalAirport": flight["arrivalAirport"],
          "priceEconomy": flight["priceEconomy"],
          "discount": flight["discount"], // إضافة الخصم إذا كان موجودًا
        };
      }).toList();
    } else {
      throw Exception('Failed to load discounted flights: ${response.body}');
    }
  }

    // دالة لجلب المقاعد المتاحة لرحلة معينة
 static Future<List<Map<String, dynamic>>> fetchAvailableSeats(String flightId) async {
  // Print the flightId to check its format
  print("Flight ID: $flightId");

  // Ensure the flightId is properly formatted before passing to the URL.
  if (!RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(flightId)) {
    throw Exception("Invalid flightId format: $flightId");
  }

  final response = await http.get(Uri.parse('$baseUrl/flights/$flightId/seats/available'));

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data.map((seat) {
      return {
        "seatNumber": seat["seatNumber"],
        "class": seat["class"],
        "price": seat["price"],
        "status": seat["status"], 
      };
    }).toList();
  } else {
    throw Exception('Failed to load available seats: ${response.body}');
  }
}



}

