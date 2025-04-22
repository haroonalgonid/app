import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          // title: const Text('من نحن'),
          // centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
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
                'نحن منصة متكاملة تربط المرضى المسافرين للعلاج حول العالم بأفضل المراكز الطبية. نقدم حلولاً شاملة لراحتكم من بداية الرحلة حتى العودة.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                'خدماتنا تشمل:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 15),
              _buildFeatureSection(
                icon: Icons.public,
                title: 'العلاج حول العالم',
                description: 'نسهل رحلتكم العلاجية لأي دولة تختارونها مثل تركيا، ألمانيا، الهند، تايلاند وغيرها',
              ),
              _buildFeatureSection(
                icon: Icons.airplane_ticket,
                title: 'حجز تذاكر السفر',
                description: 'حجز تذاكر الطيران بأفضل الأسعار مع مراعاة احتياجات المرضى',
              ),
              _buildFeatureSection(
                icon: Icons.medical_services,
                title: 'حجز المستشفيات العالمية',
                description: 'تواصل مباشر مع أفضل المستشفيات والمراكز الطبية في مختلف الدول',
              ),
              _buildFeatureSection(
                icon: Icons.hotel,
                title: 'إقامة مناسبة',
                description: 'حجز فنادق أو شقق سكنية بالقرب من المراكز العلاجية مع مراعاة احتياجات المرضى',
              ),
              // _buildFeatureSection(
              //   icon: Icons.translate,
              //   title: 'خدمات الترجمة',
              //   description: 'مترجمون طبيون متخصصون لمساعدتكم في التواصل مع الفرق الطبية',
              // ),
              _buildFeatureSection(
                icon: Icons.directions_car,
                title: 'وسائل النقل',
                description: 'تنظيم المواصلات من المطار إلى مكان الإقامة والمراكز العلاجية',
              ),
              _buildFeatureSection(
                icon: Icons.support_agent,
                title: 'دعم متكامل',
                description: 'فريق دعم على مدار الساعة لمساعدتكم في أي استفسارات أو طوارئ',
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'نهدف إلى جعل رحلتكم العلاجية في الخارج سهلة وآمنة ومريحة، حيث نتعامل مع جميع التفاصيل بدقة وعناية لنضمن لكم تجربة علاجية ناجحة.',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'نسافر معكم خطوة بخطوة نحو الشفاء',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
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
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 25, color: Colors.green),
          ),
          const SizedBox(width: 15),
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