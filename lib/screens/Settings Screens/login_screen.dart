import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:st/screens/NavigateBar.dart';
import 'package:st/theme/color.dart';
import '../../providers/Controller.dart';
import '../../service/auth_service.dart';
import 'createUser_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService apiService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Directionality(
              textDirection: TextDirection.rtl, // تحويل الاتجاه إلى RTL
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(size),
                  const SizedBox(height: 40),
                  _buildLoginForm(),
                  const SizedBox(height: 20),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Hero(
            tag: 'logoHero',
            child: Container(
              height: size.height * 0.15,
              width: size.height * 0.15,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.person,
                size: size.height * 0.08,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'مرحبًا بعودتك!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'سجل الدخول إلى حسابك',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

   Widget _buildLoginForm() {
      return Column(
        children: [
          _buildTextField(
            controller: emailController,
            label: 'البريد الإلكتروني',
            hint: 'أدخل بريدك الإلكتروني',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: passwordController,
            label: 'كلمة المرور',
            hint: 'أدخل كلمة المرور',
            icon: Icons.lock,
            isPassword: true,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            // child: TextButton(
            //   onPressed: () {
            //     // إضافة وظيفة استعادة كلمة المرور هنا
            //   },
            //   style: TextButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(horizontal: 8),
            //   ),
            //   child: const Text(
            //     'نسيت كلمة المرور؟',
            //     style: TextStyle(
            //       color: AppColors.primaryColor,
            //       fontWeight: FontWeight.w600,
            //       fontSize: 15,
            //     ),
            //   ),
            // ),
          ),
          const SizedBox(height: 24),
          _buildButton(
            onPressed: () async {
              try {
                var response = await apiService.login(
                  emailController.text,
                  passwordController.text,
                );
                // التعامل مع الاستجابة
                Get.to(
                  () => const HomePage(),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 500),
                );
              } catch (e) {
                // التعامل مع الأخطاء
                Get.snackbar('Error', e.toString());
              }
            },
            label: 'تسجيل الدخول',
            isPrimary: true,
          ),
        ],
      );
    }


  Widget _buildFooter() {
    return Column(
      children: [
        _buildDivider(),
        const SizedBox(height: 24),
        _buildButton(
          onPressed: () {
            Get.to(
              () => UserRegistrationScreen(),
              transition: Transition.rightToLeft,
              duration: const Duration(milliseconds: 500),
            );
          },
          label: 'إنشاء حساب جديد',
          isPrimary: false,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.textPrimary.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'أو',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.textPrimary.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl, // تحويل اتجاه النص في TextField
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.5),
                fontSize: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color:  AppColors.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color:  AppColors.primaryColor.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              prefixIcon: Icon(icon, color:AppColors.primaryColor),
              filled: true,
              fillColor: AppColors.cardBackground,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    bool isPrimary = true,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? AppColors.primaryColor : AppColors.background,
          foregroundColor: isPrimary ? AppColors.background : AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: isPrimary ? AppColors.primaryColor : AppColors.primaryColor,
              width: 2,
            ),
          ),
          elevation: isPrimary ? 0 : 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}