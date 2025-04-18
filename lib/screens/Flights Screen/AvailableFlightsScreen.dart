// import 'package:flutter/material.dart';

// class AvailableFlightsScreen extends StatelessWidget {
//   final List<dynamic> flights;
//   final String fromCity;
//   final String toCity;
//   final DateTime departureDate;

//   const AvailableFlightsScreen({
//     Key? key,
//     required this.flights,
//     required this.fromCity,
//     required this.toCity,
//     required this.departureDate,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('الرحلات المتاحة من $fromCity إلى $toCity'),
//       ),
//       body: ListView.builder(
//         itemCount: flights.length,
//         itemBuilder: (context, index) {
//           final flight = flights[index];
//           return Card(
//             margin: const EdgeInsets.all(10),
//             child: ListTile(
//               title: Text(flight['airline'] ?? 'غير معروف'),
//               subtitle: Text('السعر: ${flight['price'] ?? 'غير معروف'}'),
//               trailing: const Icon(Icons.arrow_forward),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }