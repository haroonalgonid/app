import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class BecomeAdminScreen extends StatelessWidget {
  const BecomeAdminScreen({super.key});

  Future<void> _launchAdminWebsite() async {
    const url = 'https://st-web-1.onrender.com';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // الحفاظ على عكس الاتجاه
      child: Scaffold(
        appBar: AppBar(
          // title: Text(
          //   'الانضمام كمشرف',
          //   style: GoogleFonts.cairo(
          //     fontWeight: FontWeight.bold,
          //     color: Colors.white,
          //   ),
          // ),
          backgroundColor: Colors.green, // تغيير إلى اللون الأخضر
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 100,
                  color: Colors.green, // تغيير لون الأيقونة إلى الأخضر
                ),
              ),
              const SizedBox(height: 30),

              Text(
                'كيف تصبح مشرفًا؟',
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // تغيير اللون إلى الأخضر
                ),
              ),
              const SizedBox(height: 20),

              _buildStep(
                number: 1,
                title: 'زيارة موقع الإدارة',
                description: 'انتقل إلى موقع تسجيل المشرفين لإنشاء حساب جديد',
              ),
              _buildStep(
                number: 2,
                title: 'إنشاء حساب مشرف',
                description:
                    'املأ نموذج التسجيل ببياناتك الصحيحة واختر "حساب مشرف"',
              ),
              _buildStep(
                number: 3,
                title: 'انتظار الموافقة',
                description:
                    'سيتم مراجعة طلبك من قبل الفريق المسؤول والموافقة عليه خلال 24 ساعة',
              ),
              _buildStep(
                number: 4,
                title: 'بدء إدارة الحجوزات',
                description:
                    'بعد الموافقة، يمكنك تسجيل الدخول وبدء إدارة حجوزات المستخدمين',
              ),
              const SizedBox(height: 30),

              Text(
                'مزايا الانضمام كمشرف:',
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // تغيير اللون إلى الأخضر
                ),
              ),
              const SizedBox(height: 10),
              _buildFeature('إدارة جميع الحجوزات (طيران، فنادق، مواعيد طبية)'),
              _buildFeature('تعديل حالة الحجوزات وتأكيدها أو إلغاؤها'),
              _buildFeature('عرض إحصائيات وأرقام الحجوزات'),
              // _buildFeature('إمكانية التواصل مع المستخدمين'),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _launchAdminWebsite,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // تغيير لون الزر إلى الأخضر
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'انتقل إلى موقع التسجيل',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'ملاحظة: سيتم التحقق من هويتك قبل الموافقة على حسابك كمشرف',
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(
      {required int number,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.green, // تغيير لون الدائرة إلى الأخضر
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle,
              color: Colors.green, size: 20), // تغيير لون الأيقونة إلى الأخضر
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
