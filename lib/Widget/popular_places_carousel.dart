// import 'package:flutter/material.dart';

// class PopularPlacesCarousel extends StatelessWidget {
//   final List<Map<String, dynamic>> places = [
//     {'image': 'https://picsum.photos/300', 'name': 'مكان سياحي 1'},
//     {'image': 'https://picsum.photos/300', 'name': 'مكان سياحي 2'},
//     {'image': 'https://picsum.photos/300', 'name': 'مكان سياحي 3'},
//   ];

//    PopularPlacesCarousel({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: places.length,
//         itemBuilder: (context, index) {
//           return Container(
//             width: 300,
//             margin: const EdgeInsets.only(right: 15),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(15),
//               child: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     places[index]['image'],
//                     fit: BoxFit.cover,
//                     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Center(
//                         child: CircularProgressIndicator(
//                           value: loadingProgress.expectedTotalBytes != null
//                               ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                               : null,
//                         ),
//                       );
//                     },
//                     errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
//                       return const Icon(Icons.error);
//                     },
//                   ),
//                   Container(
//                     decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black87,
//                         ],
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 15,
//                     left: 15,
//                     right: 15,
//                     child: Text(
//                       places[index]['name'],
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }