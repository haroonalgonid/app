// import 'package:flutter/material.dart';
// import 'enhanced_place_card.dart';

// class EnhancedRestaurantsAndHotelsGrid extends StatelessWidget {
//   final List<Map<String, dynamic>> items = [
//     {
//       'image': 'https://picsum.photos/150',
//       'name': 'مطعم الشرق',
//       'rating': 4.5,
//       'type': 'مطعم',
//     },
//     {
//       'image': 'https://picsum.photos/150',
//       'name': 'فندق النجوم',
//       'rating': 4.8,
//       'type': 'فندق',
//     },
//     {
//       'image': 'https://picsum.photos/150',
//       'name': 'مطعم البحر',
//       'rating': 4.3,
//       'type': 'مطعم',
//     },
//     {
//       'image': 'https://picsum.photos/150',
//       'name': 'فندق السلام',
//       'rating': 4.6,
//       'type': 'فندق',
//     },
//   ];

//    EnhancedRestaurantsAndHotelsGrid({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 15,
//         mainAxisSpacing: 15,
//         childAspectRatio: 0.8,
//       ),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         return EnhancedPlaceCard(
//           image: items[index]['image'],
//           name: items[index]['name'],
//           rating: items[index]['rating'],
//           type: items[index]['type'],
//         );
//       },
//     );
//   }
// }