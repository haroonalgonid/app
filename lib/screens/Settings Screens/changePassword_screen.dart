import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../service/TokenManager.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? token;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    token = await TokenManager.getAccessToken();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (token == null) {
      _showSnackbar("لم يتم العثور على التوكين، يرجى تسجيل الدخول مجددًا", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('https://backend-fpnx.onrender.com/auth/change-password');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'oldPassword': _currentPasswordController.text,
      'newPassword': _newPasswordController.text,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);
      setState(() => _isLoading = false);

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSnackbar(responseData['message'] ?? 'تم تغيير كلمة المرور بنجاح');
        _clearForm();
      } else {
        _showSnackbar(responseData['message'] ?? 'فشل في تغيير كلمة المرور', isError: true);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackbar('حدث خطأ أثناء الاتصال بالسيرفر', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'خطأ' : 'تم بنجاح',
      message,
      icon: Icon(
        isError ? Icons.error : Icons.check_circle,
        color: isError ? Colors.red : Colors.green,
      ),
      snackPosition: SnackPosition.TOP,
      colorText: Colors.black,
      duration: const Duration(seconds: 3),
    );
  }

  void _clearForm() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: Container(), // إزالة أيقونة الرجوع الافتراضية
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Transform.flip(
                flipX: true, // قلب الأيقونة أفقيًا
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            _buildPasswordField(
                              _currentPasswordController,
                              "كلمة المرور الحالية",
                              Icons.lock,
                              _showCurrentPassword,
                              (value) {
                                setState(() {
                                  _showCurrentPassword = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildPasswordField(
                              _newPasswordController,
                              "كلمة المرور الجديدة",
                              Icons.lock_outline,
                              _showNewPassword,
                              (value) {
                                setState(() {
                                  _showNewPassword = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildPasswordField(
                              _confirmPasswordController,
                              "تأكيد كلمة المرور الجديدة",
                              Icons.lock_outline,
                              _showConfirmPassword,
                              (value) {
                                setState(() {
                                  _showConfirmPassword = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "يرجى تأكيد كلمة المرور الجديدة";
                                }
                                if (value != _newPasswordController.text) {
                                  return "كلمة المرور غير متطابقة";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF4CAF50)))
                          : ElevatedButton(
                              onPressed: _changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock_reset, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    "تغيير كلمة المرور",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool showPassword,
    Function(bool) onEyePressed, {
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      decoration: _inputDecoration(label, icon, showPassword, onEyePressed),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return "يرجى إدخال $label";
            }
            if (label == "كلمة المرور الجديدة" && value.length < 6) {
              return "كلمة المرور يجب أن تكون على الأقل 6 أحرف";
            }
            return null;
          },
    );
  }

  InputDecoration _inputDecoration(
    String label,
    IconData icon,
    bool showPassword,
    Function(bool) onEyePressed,
  ) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF4CAF50)),
      prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
      suffixIcon: IconButton(
        icon: Icon(
          showPassword ? Icons.visibility : Icons.visibility_off,
          color: const Color(0xFF4CAF50)),
        onPressed: () => onEyePressed(!showPassword),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}