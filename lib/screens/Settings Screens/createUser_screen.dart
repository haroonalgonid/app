import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:st/theme/color.dart';

import '../../service/createUser_service.dart';
import '../NavigateBar.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedGender = 'ذكر';
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final List<String> _genderOptions = ['ذكر', 'أنثى'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          TextDirection.rtl, // تغيير اتجاه الصفحة إلى اليمين إلى اليسار
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.background,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معلومات المستخدم',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // تغيير لون النص إلى الأخضر
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _nameController,
                  label: 'الاسم الكامل',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الاسم الرباعي';
                    }
                    final words = value.trim().split(RegExp(r'\s+'));
                    if (words.length < 4) {
                      return 'الرجاء إدخال الاسم الرباعي كاملًا';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildTextField(
                  controller: _phoneController,
                  label: 'رقم الهاتف',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                _buildDatePicker(),
                _buildGenderSelector(),
                _buildTextField(
                  controller: _addressController,
                  label: 'العنوان',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 30),
                const Text(
                  'معلومات الأمان',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // تغيير لون النص إلى الأخضر
                  ),
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _passwordController,
                  label: 'كلمة المرور',
                  isVisible: _isPasswordVisible,
                  onVisibilityChanged: (value) =>
                      setState(() => _isPasswordVisible = value),
                ),
                _buildPasswordField(
                  controller: _confirmPasswordController,
                  label: 'تأكيد كلمة المرور',
                  isVisible: _isConfirmPasswordVisible,
                  onVisibilityChanged: (value) =>
                      setState(() => _isConfirmPasswordVisible = value),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      void _showMessageDialog(
                        BuildContext context, {
                        required String title,
                        required String message,
                        required IconData icon,
                        required Color iconColor,
                      }) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              title: Row(
                                children: [
                                  Icon(icon, color: iconColor, size: 30),
                                  const SizedBox(width: 10),
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: iconColor,
                                    ),
                                  ),
                                ],
                              ),
                              content: Text(
                                message,
                                style: const TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('موافق',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            );
                          },
                        );
                      }

  if (_formKey.currentState!.validate()) {
    final userData = {
      "fullName": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "birthDate": _dobController.text,
      "gender": _selectedGender,
      "address": _addressController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await CreateUserService.registerUser(userData);
      if (response.containsKey('message')) {
        // عرض رسالة النجاح
        Get.snackbar(
          'تم التسجيل بنجاح',
          response['message'],
          icon: Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
          duration: Duration(seconds: 3),
        );
        
        // الانتقال إلى الشاشة الرئيسية بعد التأخير
        Future.delayed(Duration(seconds: 2), () {
          Get.offAll(() => HomePage()); // استبدل HomeScreen بشاشتك الرئيسية
        });
      } else {
        Get.snackbar(
          'خطأ غير متوقع',
          'لم يتم استلام رسالة من الخادم.',
          icon: Icon(Icons.warning, color: Colors.blue),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.black,
        duration: Duration(seconds: 3),
      );
    }
  }
},

                    
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      backgroundColor:
                          Colors.green, // تغيير لون الزر إلى الأخضر
                    ),
                    child: const Text(
                      'إنشاء الحساب',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:
              Icon(icon, color: Colors.green), // تغيير لون الأيقونة إلى الأخضر
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال $label';
              }
              return null;
            },
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required Function(bool) onVisibilityChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock,
              color: Colors.green), // تغيير لون الأيقونة إلى الأخضر
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.green, // تغيير لون الأيقونة إلى الأخضر
            ),
            onPressed: () => onVisibilityChanged(!isVisible),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال $label';
              }
              return null;
            },
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _dobController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'تاريخ الميلاد',
          prefixIcon: const Icon(Icons.calendar_today,
              color: Colors.green), // تغيير لون الأيقونة إلى الأخضر
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() {
              _dobController.text = "${picked.toLocal()}".split(' ')[0];
            });
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى إدخال تاريخ الميلاد';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: 'الجنس',
          prefixIcon: const Icon(Icons.people,
              color: Colors.green), // تغيير لون الأيقونة إلى الأخضر
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        items: _genderOptions.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue!;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'يرجى اختيار الجنس';
          }
          return null;
        },
      ),
    );
  }
}
