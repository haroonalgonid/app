import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('سياسة الاستخدام'),
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
                  Icons.privacy_tip,
                  size: 100,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),
              _buildPolicySection(
                title: "1. قبول الشروط",
                content:
                "باستخدامك تطبيق Sick Traveler، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على هذه الشروط، يرجى عدم استخدام التطبيق.",
              ),
              _buildPolicySection(
                title: "2. وصف الخدمة",
                content:
                "يوفر التطبيق وساطة بين المرضى المسافرين إلى مصر للعلاج والمستشفيات والمراكز الطبية، بما في ذلك خدمات حجز التذاكر والفنادق ووسائل النقل.",
              ),
              _buildPolicySection(
                title: "3. المسؤولية",
                content:
                "نحن لسنا مسؤولين عن أي أخطاء طبية أو تأخيرات في الخدمات المقدمة من قبل المستشفيات أو مقدمي الخدمات الآخرين.",
              ),
              _buildPolicySection(
                title: "4. الخصوصية",
                content:
                "نحن نحترم خصوصيتك. جميع البيانات الشخصية التي تقدمها تخضع لسياسة الخصوصية الخاصة بنا والتي يمكنك الاطلاع عليها في قسم سياسة الخصوصية.",
              ),
              _buildPolicySection(
                title: "5. التعديلات",
                content:
                "نحتفظ بالحق في تعديل هذه الشروط في أي وقت. سيتم إعلامك بأي تغييرات عبر التطبيق أو البريد الإلكتروني.",
              ),
              _buildPolicySection(
                title: "6. القيود",
                content:
                "يجب ألا تستخدم التطبيق لأغراض غير قانونية أو تنتهك حقوق الآخرين أو تتعارض مع أي قوانين محلية أو دولية.",
              ),
              _buildPolicySection(
                title: "7. الاتصال بنا",
                content:
                "لأية استفسارات بخصوص سياسة الاستخدام، يمكنك التواصل معنا عبر البريد الإلكتروني: support@sicktraveler.com",
              ),
              const SizedBox(height: 30),
              const Text(
                "آخر تحديث: 1 يناير 2023",
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
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
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}