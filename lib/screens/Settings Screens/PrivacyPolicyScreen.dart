import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          // title: const Text('سياسة الخصوصية والشروط'),
          // centerTitle: true,
          backgroundColor: Colors.green,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Icon(
                  Icons.security,
                  size: 100,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'سياسة الخصوصية وشروط الاستخدام',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildPolicySection(
                title: "1. القبول والشروط العامة",
                content:
                    "باستخدامك تطبيق Sick Traveler، فإنك توافق على الالتزام بهذه الشروط والأحكام وسياسة الخصوصية. يرجى عدم استخدام التطبيق إذا كنت لا توافق على هذه الشروط.",
              ),
              _buildPolicySection(
                title: "2. نطاق الخدمة",
                content:
                    "نحن نقدم وساطة متكاملة لخدمات السفر العلاجي حول العالم، تشمل التواصل مع المراكز الطبية الدولية، حجز التذاكر، ترتيب الإقامة، تنظيم المواصلات.",
              ),
              _buildPolicySection(
                title: "3. حماية البيانات",
                content:
                    "نحن نحمي بياناتك الشخصية وفق أعلى المعايير الأمنية. يتم تشفير البيانات الحساسة ولا نشارك معلوماتك مع أطراف ثالثة دون موافقتك الصريحة إلا عند الضرورة القانونية.",
              ),
              _buildPolicySection(
                title: "4. البيانات التي نجمعها",
                content:
                    "نجمع المعلومات الضرورية لتقديم الخدمة مثل: البيانات الشخصية، التاريخ الطبي، تفاصيل السفر. نستخدم هذه البيانات فقط لغرض تقديم وتحسين خدماتنا.",
              ),
              _buildPolicySection(
                title: "5. مسؤولية المستخدم",
                content:
                    "أنت مسؤول عن: دقة المعلومات المقدمة، الحفاظ على سرية حسابك، استخدام التطبيق لأغراض مشروعة فقط، وعدم انتهاك حقوق الآخرين أو القوانين المحلية والدولية.",
              ),
              _buildPolicySection(
                title: "6. حدود مسؤوليتنا",
                content:
                    "نحن لسنا مسؤولين عن: النتائج العلاجية، أخطاء مقدمي الخدمات الطبية، التأخيرات أو المشاكل الناتجة عن ظروف خارجة عن إرادتنا مثل الكوارث الطبيعية أو الإضرابات.",
              ),
              // _buildPolicySection(
              //   title: "7. المدفوعات والاسترداد",
              //   content:
              //       "جميع المعاملات المالية تتم عبر بوابات دفع آمنة. سياسة الاسترداد تخضع لشروط مقدم الخدمة (المستشفى، الفندق، شركة الطيران) وقد تختلف حسب كل حالة.",
              // ),
              _buildPolicySection(
                title: "7. التعديلات على السياسة",
                content:
                    "نحتفظ بحق تعديل هذه السياسة عند الحاجة. سيتم إعلامك بالتغييرات الجوهرية عبر البريد الإلكتروني أو إشعار في التطبيق. استمرار استخدامك للتطبيق بعد التعديلات يعني قبولك لها.",
              ),
              _buildPolicySection(
                title: "8. الملكية الفكرية",
                content:
                    "جميع محتويات التطبيق (نصوص، صور، شعارات، تصميم) محمية بحقوق الملكية الفكرية. لا يحق لك استخدامها دون إذن كتابي مسبق منا.",
              ),
              _buildPolicySection(
                title: "9. الاتصال بنا",
                content:
                    "لأية استفسارات حول السياسة أو الخدمات، يرجى التواصل معنا عبر:\nالبريد الإلكتروني: haroonalgonid @gmail.com\nالهاتف:773072639 \nساعات العمل: من الأحد إلى الخميس، 9 صباحاً - 5 مساءً",
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "نحن ملتزمون بحماية خصوصيتك وتقديم خدمة آمنة وموثوقة لراحتكم وطمأنتكم خلال رحلتكم العلاجية.",
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // const Center(
              //   child: Text(
              //     "آخر تحديث: 1 يناير 2024",
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: Colors.grey,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}