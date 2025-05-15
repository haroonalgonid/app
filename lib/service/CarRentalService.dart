import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TokenManager.dart';

class CarRentalService {
  static const String baseUrl = "https://backend-fpnx.onrender.com";

  // Get all car rentals with specific fields
// Get all car rentals with specific fields
static Future<List<Map<String, dynamic>>?> getCarRentals() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/carrental'));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> companiesData = responseData["companies"] ?? [];

      return companiesData.map<Map<String, dynamic>>((item) {
        var company = item["company"] ?? {};
        return {
          "id": company["_id"],
          "name": company["name"],
          "type": company["type"],
          "address": company["address"],
          "logo": company["logo"],
          "phoneNumber": company["phoneNumber"],
          "website": company["website"],
          "email": company["email"],
          "description": company["description"],
          "facilities": List<String>.from(company["facilities"] ?? []),
          "images": List<String>.from(company["images"] ?? []),
          "commercialRecord": company["commercialRecord"],
          "license": company["license"],
          "moderatorId": company["moderatorId"],
          "isApproved": company["isApproved"] ?? false,
          "createdAt": company["createdAt"],
          "updatedAt": company["updatedAt"],
          "__v": company["__v"],
          "averageRating": (item["averageRating"] as num?)?.toDouble() ?? 0.0,
          "totalReviews": item["totalReviews"] ?? 0,
        };
      }).toList();
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    print("Exception in getCarRentals: $e");
  }
  return null;
}


  static Future<bool> addCarRentalReview(
      String rentalId, int rating, String comment) async {
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
          "carRental": rentalId,
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
      print("Exception in addCarRentalReview: $e");
    }
    return false;
  }

  // Get car rental reviews and rating
  static Future<List<Map<String, dynamic>>?> getCarRentalReviews(
      String rentalId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/hospitals/reviews/average?carRentalId=$rentalId'),
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
            "Error fetching reviews: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("Exception in getCarRentalReviews: $e");
    }
    return null;
  }

  // Get cars for a specific rental
 static Future<List<Map<String, dynamic>>?> getRentalCars(String rentalCompanyId) async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/carrental/$rentalCompanyId/cars'));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> carsData = responseData["cars"] ?? [];

      return carsData.map<Map<String, dynamic>>((car) {
        return {
          "id": car["_id"],
          "rentalCompanyId": car["rentalCompany"]["_id"],
          "rentalCompanyName": car["rentalCompany"]["name"],
          "rentalCompanyAddress": car["rentalCompany"]["address"],
          "make": car["make"],
          "model": car["model"],
          "year": car["year"],
          "type": car["type"],
          "pricePerDay": car["pricePerDay"],
          "seats": car["seats"],
          "transmission": car["transmission"],
          "fuelType": car["fuelType"],
          "mileage": car["mileage"],
          "features": List<String>.from(car["features"] ?? []),
          "images": List<String>.from(car["images"] ?? []),
          "isAvailable": car["isAvailable"],
          "plateNumber": car["plateNumber"],
          "createdAt": car["createdAt"],
          "updatedAt": car["updatedAt"],
          "__v": car["__v"]
        };
      }).toList();
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    print("Exception in getRentalCars: $e");
  }
  return null;
}


 static Future<Map<String, dynamic>?> bookCar({
  required String carId,
  required String pickupDate,
  required String returnDate,
  required String pickupLocation,
  required String returnLocation,
  required String driverLicenseNumber,
}) async {
  try {
    String? accessToken = await TokenManager.getAccessToken();
    if (accessToken == null) {
      print("Error: No access token found");
      return null;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/carrental/bookings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        "car": carId,
        "pickupDate": pickupDate,
        "returnDate": returnDate,
        "pickupLocation": pickupLocation,
        "returnLocation": returnLocation,
        "driverLicenseNumber": driverLicenseNumber,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    print("Exception in bookCar: $e");
  }
  return null;
}

}
