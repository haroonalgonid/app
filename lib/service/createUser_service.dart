import 'dart:convert';
import 'package:http/http.dart' as http;
import '../screens/Settings Screens/Global.dart';
import 'TokenManager.dart';

class CreateUserService {
  static const String baseUrl = 'https://backend-fpnx.onrender.com';

  static Future<Map<String, dynamic>> registerUser(Map<String, dynamic> userData) async {
    // أضف fcmToken إلى بيانات المستخدم
    if (globalFcmToken != null) {
      userData['fcmToken'] = globalFcmToken;
    } else {
      print("تحذير: FCM Token غير متوفر");
    }

    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String accessToken = responseData['accessToken'];
      String refreshToken = responseData['refreshToken'];

      await TokenManager.saveTokens(accessToken, refreshToken);

      print('تم تسجيل المستخدم بنجاح');
      print('Access Token: $accessToken');
      print('Refresh Token: $refreshToken');

      return responseData;
    } else {
      throw Exception('فشل في تسجيل المستخدم: ${response.body}');
    }
  }
}