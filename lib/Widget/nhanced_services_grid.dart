// import 'package:flutter/material.dart';
// import 'enhanced_service_icon.dart';

// class EnhancedServicesGrid extends StatelessWidget {
//   final List<Map<String, dynamic>> services = [
//     {
//       'icon': Icons.airplanemode_active,
//       'label': 'تذاكر الطيران',
//       'color': Colors.blue,
//       'route': '/flight_tickets',
//     },
//     {
//       'icon': Icons.local_hospital,
//       'label': 'المستشفيات',
//       'color': Colors.red,
//       'route': '/hospitals',
//     },
//     {
//       'icon': Icons.hotel,
//       'label': 'الفنادق',
//       'color': Colors.amber,
//       'route': '/hotels',
//     },
//     {
//       'icon': Icons.restaurant,
//       'label': 'المطاعم',
//       'color': Colors.green,
//       'route': '/restaurants',
//     },
//     {
//       'icon': Icons.directions_bus,
//       'label': 'المواصلات',
//       'color': Colors.purple,
//       'route': '/transportation',
//     },
//   ];

//    EnhancedServicesGrid({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // تحديد عدد الأعمدة بناءً على عرض الشاشة
//         int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        
//         return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: crossAxisCount,
//             crossAxisSpacing: constraints.maxWidth * 0.03,
//             mainAxisSpacing: constraints.maxHeight * 0.03,
//             childAspectRatio: 1,
//           ),
//           itemCount: services.length,
//           itemBuilder: (context, index) {
//             return EnhancedServiceIcon(
//               icon: services[index]['icon'],
//               label: services[index]['label'],
//               color: services[index]['color'],
//               onTap: () {
//                 Navigator.pushNamed(context, services[index]['route']);
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
