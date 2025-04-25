import 'dart:convert';
import 'package:http/http.dart' as http;

import 'TokenManager.dart';

class HospitalService {
  static const String baseUrl = "https://backend-fpnx.onrender.com";

  // Get all hospitals with specific fields
static Future<List<Map<String, dynamic>>?> getHospitals() async {
  try {
    final response = await http.get(Uri.parse('$baseUrl/hospitals/hospitals'));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      List<dynamic> hospitalsData = responseData["hospitals"] ?? [];

      return hospitalsData.map<Map<String, dynamic>>((hospitalEntry) {
        final hospital = hospitalEntry["hospital"];
        
        // التأكد من إضافة baseUrl لجميع الصور
        List<String> images = hospital["images"] != null
            ? List<String>.from(hospital["images"].map((img) => '$baseUrl/$img'))
            : [];

        return {
          "id": hospital["_id"],
          "name": hospital["name"],
          "type": hospital["type"],
          "address": hospital["address"],
          "logo": hospital["logo"] != null ? '${hospital["logo"]}' : '',  // إصلاح رابط الشعار
          "facilities": hospital["facilities"] ?? [],
          "averageRating": hospitalEntry["averageRating"] ?? 0.0,
          "images": images,  // استخدام الروابط الكاملة للصور
        };
      }).toList();
    } else {
      print("Error: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    print("Exception in getHospitals: $e");
  }
  return null;
}



  // Get specific hospital details
static Future<Map<String, dynamic>?> getHospitalDetails(
    String hospitalId) async {
  try {
    final response =
        await http.get(Uri.parse('$baseUrl/hospitals/$hospitalId'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      final hospital = data["hospital"];

      // إنشاء روابط كاملة للصور
      List<String> fullImageUrls = (hospital["images"] as List<dynamic>?)
              ?.map((image) => "$image")
              .cast<String>()
              .toList() ?? 
          [];

      return {
        "id": hospital["_id"],
        "name": hospital["name"],
        "address": hospital["address"],
        "facilities": hospital["facilities"],
        "type": hospital["type"],
        "images": fullImageUrls, // استخدام الروابط الكاملة للصور
        "phoneNumber": hospital["phoneNumber"],
        "website": hospital["website"],
        "email": hospital["email"],
        "description" : hospital["description"],
        "logo": hospital["logo"] != null ? '${hospital["logo"]}' : '',  // إصلاح رابط الشعار
      };
    } else {
      print("Error fetching hospital details: ${response.body}");
    }
  } catch (e) {
    print("Exception in getHospitalDetails: $e");
  }
  return null;
}


  // Get doctors of a specific hospital
  static Future<List<Map<String, dynamic>>?> getHospitalDoctors(
      String hospitalId) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/hospitals/$hospitalId/doctors"));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if 'doctors' key exists and is a list
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('doctors')) {
          List<dynamic> doctorsData = responseData['doctors'];

          return doctorsData.map<Map<String, dynamic>>((doctor) {
            return {
              "id": doctor["_id"],
              "name": doctor["name"],
              "specialty": doctor["specialty"],
              "experienceYears": doctor["experienceYears"],
              "bio": doctor["bio"] ?? "No bio available",
              "hospitalName": doctor["hospital"]["name"],
              "hospitalAddress": doctor["hospital"]["address"],
              "image": doctor["image"] ?? "https://via.placeholder.com/150",
            };
          }).toList();
        } else {
          print("Doctors data not found in the response.");
        }
      } else {
        print("Error fetching doctors: ${response.body}");
      }
    } catch (e) {
      print("Exception in getHospitalDoctors: $e");
    }
    return null;
  }

  // Get hospital reviews with detailed data
  static Future<Map<String, dynamic>?> getHospitalReviews(
      String hospitalId) async {
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/hospitals/reviews/average?hospitalId=$hospitalId"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        return {
          "averageRating": data["averageRating"]?.toDouble(),
          "totalReviews": data["totalReviews"],
          "reviewsData": data["reviewsData"]
              ?.map((review) => {
                    "userId": review["user"]["id"],
                    "fullName": review["user"]["fullName"],
                    "email": review["user"]["email"],
                    "comment": review["comment"],
                    "rating": review["rating"],
                    "createdAt": review["createdAt"]
                  })
              .toList()
        };
      } else {
        print("Error fetching hospital reviews: ${response.body}");
      }
    } catch (e) {
      print("Exception in getHospitalReviews: $e");
    }

    return null;
  }

  // Get doctor reviews with detailed data
  static Future<Map<String, dynamic>?> getDoctorReviews(String doctorId) async {
    try {
      final response = await http.get(
          Uri.parse("$baseUrl/hospitals/reviews/average?doctorId=$doctorId"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        return {
          "averageRating": data["averageRating"]?.toDouble(),
          "totalReviews": data["totalReviews"],
          "reviewsData": data["reviewsData"]
              ?.map((review) => {
                    "userId": review["user"]["id"],
                    "fullName": review["user"]["fullName"],
                    "email": review["user"]["email"],
                    "comment": review["comment"],
                    "rating": review["rating"],
                    "createdAt": review["createdAt"]
                  })
              .toList()
        };
      } else {
        print("Error fetching doctor reviews: ${response.body}");
      }
    } catch (e) {
      print("Exception in getDoctorReviews: $e");
    }

    return null;
  }

//Add hospital review
  static Future<bool> addHospitalReview({
    required String hospitalId,
    required int rating,
    required String comment,
  }) async {
    try {
      String? token = await TokenManager.getAccessToken();
      if (token == null) {
        print("No access token found, user might be logged out.");
        return false;
      }

      final response = await http.post( 
        Uri.parse("$baseUrl/hospitals/reviews"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "hospital": hospitalId,
          "rating": rating,
          "comment": comment,
        }),
      );

      // طباعة الاستجابة
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        print("Review added successfully!");
        return true;
      } else {
        print("Error adding review: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in addHospitalReview: $e");
      return false;
    }
  }

//Add doctor review
  static Future<bool> addDoctorReview({
    required String doctorId,
    required int rating,
    required String comment,
  }) async {
    try {
      String? token = await TokenManager.getAccessToken();
      if (token == null) {
        print("No access token found, user might be logged out.");
        return false;
      }

      final response = await http.post(
        Uri.parse(
            "$baseUrl/hospitals/reviews"), // تغيير الرابط ليناسب تقييم الأطباء
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "doctor": doctorId, // استخدام doctorId بدلاً من hospitalId
          "rating": rating,
          "comment": comment,
        }),
      );

      // طباعة الاستجابة
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        print("Doctor review added successfully!");
        return true;
      } else {
        print("Error adding doctor review: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception in addDoctorReview: $e");
      return false;
    }
  }

// Get specific doctor details
  static Future<Map<String, dynamic>?> getDoctorDetails(String doctorId) async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/hospitals/doctors/$doctorId"));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        final doctor = data["doctor"];

        return {
          "id": doctor["_id"],
          "name": doctor["name"],
          "specialty": doctor["specialty"],
          "experienceYears": doctor["experienceYears"],
          "bio": doctor["bio"],
          "hospital": {
            "id": doctor["hospital"]["_id"],
            "name": doctor["hospital"]["name"],
            "address": doctor["hospital"]["address"]
          },
          "createdAt": doctor["createdAt"],
          "updatedAt": doctor["updatedAt"],
          "averageRating": data["averageRating"],
          "totalReviews": data["totalReviews"]
        };
      } else {
        print("Error fetching doctor details: ${response.body}");
      }
    } catch (e) {
      print("Exception in getDoctorDetails: $e");
    }
    return null;
  }

  // ✅ جلب أوقات دوام الطبيب
  static Future<List<Map<String, dynamic>>?> getDoctorSchedules(
      String doctorId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/hospitals/schedules/$doctorId'));

      if (response.statusCode == 200) {
        List<dynamic> schedulesData =
            jsonDecode(response.body)["schedules"] ?? [];

        return schedulesData.map<Map<String, dynamic>>((schedule) {
          return {
            "startDate": schedule["startDate"],
            "endDate": schedule["endDate"],
            "startTime": schedule["startTime"],
            "endTime": schedule["endTime"],
            "slotDuration": schedule["slotDuration"],
          };
        }).toList();
      } else {
        print("Error fetching schedules: ${response.body}");
      }
    } catch (e) {
      print("Exception in getDoctorSchedules: $e");
    }
    return null;
  }

  // ✅ حجز موعد مع إرسال التوكن
  static Future<String?> bookAppointment({
    required String doctorId,
    required String dateTime,
  }) async {
    try {
      String? token = await TokenManager.getAccessToken();
      if (token == null) {
        return "No access token found, user might be logged out.";
      }

      final response = await http.post(
        Uri.parse("$baseUrl/hospitals/appointment"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "doctorId": doctorId,
          "dateTime": dateTime,
        }),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201) {
        return null; // نجاح الحجز
      } else {
        // تحليل رسالة الخطأ من الـ backend
        final responseData = jsonDecode(response.body);
        return responseData['message'] ?? "فشل في حجز الموعد";
      }
    } catch (e) {
      return "حدث خطأ أثناء محاولة حجز الموعد: $e";
    }
  }
}