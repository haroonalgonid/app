// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AirlineInfoScreen extends StatelessWidget {
//   final Map<String, dynamic> airline;

//   const AirlineInfoScreen({super.key, required this.airline});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("معلومات الشركة",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 8,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Text(
//                       'معلومات الشركة',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   _buildInfoTile('اسم الشركة', airline["companyName"].toString(), Icons.business),
//                   _buildInfoTile('الوصف', airline["description"].toString(), Icons.description),
//                   _buildInfoTile('البريد الإلكتروني', airline["email"].toString(), Icons.email),
//                   _buildInfoTile('رقم الهاتف', airline["phoneNumber"].toString(), Icons.phone),
//                   _buildInfoTile('الموقع الإلكتروني', airline["website"].toString(), Icons.web, isLink: true),
//                   _buildInfoTile('العنوان', airline["headquartersAddress"].toString(), Icons.location_on),
//                   _buildInfoTile('الدول التي تعمل بها', airline["countriesOperated"].toString(), Icons.flag),
//                   _buildInfoTile('المدن التي تعمل بها', airline["citiesOperated"].toString(), Icons.location_city),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoTile(String title, String value, IconData icon, {bool isLink = false}) {
//   return ListTile(
//     leading: Icon(icon, color: Colors.blue),
//     title: Text(title, style: const TextStyle(color: Colors.grey)),
//     trailing: isLink
//         ? InkWell(
//             onTap: () async {
//               final Uri url = Uri.parse(value);
//               if (await canLaunchUrl(url)) {
//                 await launchUrl(url, mode: LaunchMode.externalApplication);
//               } else {
//                 throw 'لا يمكن فتح الرابط: $value';
//               }
//             },
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           )
//         : Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//   );
// }
// }