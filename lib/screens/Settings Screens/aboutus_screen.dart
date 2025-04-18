import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // هذا السطر يجعل الشاشة RTL
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('من نحن'),
          // centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Icon(
                  Icons.medical_services,
                  size: 120,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'مرحباً بكم في تطبيق Sick Traveler',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'نحن وسيط بين الشخص المريض المسافر إلى مصر لغرض العلاج والمستشفيات والمراكز الطبية. نسعى لتسهيل رحلتكم العلاجية من البداية حتى النهاية.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              _buildFeatureSection(
                icon: Icons.airplane_ticket,
                title: 'حجز تذاكر السفر',
                description: 'نسهل عملية السفر من خلال حجز تذاكر الطيران إلى مصر.',
              ),
              _buildFeatureSection(
                icon: Icons.local_hospital,
                title: 'حجز المستشفيات والمراكز الطبية',
                description: 'نوفر قائمة بأفضل المستشفيات والمراكز الطبية مع إمكانية الحجز المباشر.',
              ),
              _buildFeatureSection(
                icon: Icons.hotel,
                title: 'حجز الفنادق',
                description: 'نسهل عملية حجز الغرف أو الشقق في الفنادق مع تحديد مواقعها بالقرب من المراكز العلاجية.',
              ),
              _buildFeatureSection(
                icon: Icons.directions_car,
                title: 'وسائل النقل',
                description: 'إمكانية حجز وسائل النقل داخل مصر من خلال التطبيق.',
              ),
              _buildFeatureSection(
                icon: Icons.restaurant,
                title: 'خدمات المطاعم',
                description: 'توفير قائمة بالمطاعم مع تحديد مواقعها وإمكانية طلب الوجبات مع خدمة التوصيل.',
              ),
              _buildFeatureSection(
                icon: Icons.rate_review,
                title: 'تقييم الخدمات',
                description: 'إمكانية تقييم المستشفيات والأطباء والمراكز الطبية والفنادق والمطاعم لمساعدة المستخدمين الآخرين.',
              ),
              const SizedBox(height: 30),
              const Text(
                'نحن هنا لنجعل رحلتكم العلاجية أسهل وأكثر راحة.',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSection({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}