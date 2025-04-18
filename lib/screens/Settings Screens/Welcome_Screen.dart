import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'مرحبًا بك في دليل المسافر المريض!',
                  style: TextStyle(
                    fontSize: 22, // تصغير حجم الخط
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12), // تقليل المسافة الفارغة
                Expanded(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(), // تعطيل التمرير
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16), // تقليل الحشو
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'نحن سعداء باستقبالك في تطبيقنا الذي صمم خصيصًا لتسهيل رحلتك وضمان راحتك وسلامتك أينما كنت. مع دليل المسافر المريض، يمكنك:',
                                style: TextStyle(
                                  fontSize: 14, // تصغير حجم الخط
                                  height: 1.4,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.right,
                              ),
                              SizedBox(height: 12),
                              _buildFeatureItem(
                                icon: Icons.airplane_ticket,
                                text: 'حجز تذاكر الطيران بسهولة وسرعة.',
                              ),
                              _buildFeatureItem(
                                icon: Icons.restaurant_menu,
                                text: 'استكشاف المطاعم المحلية والدولية واختيار أفضل الوجبات.',
                              ),
                              _buildFeatureItem(
                                icon: Icons.local_hospital,
                                text: 'العثور على المستشفيات والأطباء المتخصصين في منطقتك.',
                              ),
                              _buildFeatureItem(
                                icon: Icons.delivery_dining,
                                text: 'طلب خدمات التوصيل للوصول إلى وجهتك بأمان.',
                              ),
                              _buildFeatureItem(
                                icon: Icons.hotel,
                                text: 'استعراض الفنادق واختيار الأفضل لإقامتك.',
                              ),
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'نحن هنا لنجعل رحلتك أكثر سهولة وأمانًا. استمتع بتجربتك معنا!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blue[800],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Image.asset(
                          'assets/images/welcomeimage.png',
                          height: 400, // تصغير حجم الصورة
                          width: 400,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.mediumImpact();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('welcomeSeen', true);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(
                      fontSize: 16, // تصغير حجم خط الزر
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('لنبدأ الآن'),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue[700],
              size: 18, // تصغير حجم الأيقونات
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14, // تصغير حجم الخط
                height: 1.3,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}