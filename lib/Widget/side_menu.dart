import 'package:flutter/material.dart';

// import '../screens/Flights Screen/admin/dashboard_screen.dart';
import '../screens/Settings Screens/PrivacyPolicyScreen.dart';
import '../screens/Settings Screens/Welcome_Screen.dart';
import '../screens/Settings Screens/aboutus_screen.dart';
import '../screens/Settings Screens/become_admin_screen.dart';
import '../screens/Settings Screens/changePassword_screen.dart';
import '../screens/Settings Screens/login_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text(
              'القائمة الجانبية',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          // ListTile(
          //   leading: const Icon(Icons.language),
          //   title: const Text('اللغة'),
          //   onTap: () {
          //     // تنفيذ تغيير اللغة
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) =>
          //             AccountTypeScreen(), // الانتقال إلى شاشة PatientSignUpScreen
          //       ),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(' انشاء حساب'),
            onTap: () {
              // الانتقال إلى شاشة الحساب
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      LoginScreen(), // الانتقال إلى شاشة PatientSignUpScreen
                ),
              );
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.account_circle),
          //   title: const Text('البروفايل'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) =>
          //             AdminFlightsScreen(), // الانتقال إلى شاشة PatientSignUpScreen
          //       ),
          //     ); // إغلاق القائمة الجانبية
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('تغيير كلمة المرور'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ChangePasswordScreen(), // الانتقال إلى شاشة PatientSignUpScreen
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_add_alt_1), // أيقونة إضافة شخص
            title: const Text('كيفية الانضمام'), // نص جديد
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BecomeAdminScreen(),
                ),
              );
            },
          ),
              ListTile(
  leading: const Icon(Icons.info_outline), // أيقونة معلومات
  title: const Text('من نحن'), // النص المعروض
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AboutUsScreen(),
      ),
    );
  },
),
ListTile(
  leading: const Icon(Icons.policy), // أيقونة سياسة
  title: const Text('سياسة الاستخدام'),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  const PrivacyPolicyScreen(),
      ),
    );
  },
),

        ],
      ),
    );
  }
}
