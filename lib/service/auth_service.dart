import 'dart:convert';
import 'package:http/http.dart' as http;
import 'TokenManager.dart'; // تأكد من استيراد كلاس TokenManager

class AuthService {
  final String baseUrl = "https://backend-fpnx.onrender.com"; // استبدل بـ URL الخاص بك

  Future<dynamic> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // استلام البيانات من الخادم
        var data = jsonDecode(response.body);

        // استخراج التوكنات من البيانات
        String accessToken = data['accessToken'];
        String refreshToken = data['refreshToken'];

        // تخزين التوكنات باستخدام TokenManager
        await TokenManager.saveTokens(accessToken, refreshToken);

        // استدعاء التوكن للتحقق
        String? token = await TokenManager.getAccessToken();
        print("Token After Login: $token");

        return data; // يمكنك إعادة البيانات أو أي شيء تريده
      } else {
        // عرض رسالة خطأ مع كود الحالة
        print("فشل في تسجيل الدخول: ${response.statusCode}");
        throw Exception('فشل في تسجيل الدخول');
      }
    } catch (e) {
      print("خطأ: $e");
      throw Exception("حدث خطأ أثناء محاولة تسجيل الدخول");
    }
  }
}
