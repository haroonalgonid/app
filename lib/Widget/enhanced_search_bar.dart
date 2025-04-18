// import 'package:flutter/material.dart';

// class EnhancedSearchBar extends StatelessWidget {
//   final Function(String)? onSearch;
//   final VoidCallback? onVoiceSearch;

//   EnhancedSearchBar({this.onSearch, this.onVoiceSearch});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.15), // لون مع شفافية خفيفة
//         borderRadius: BorderRadius.circular(25), // زوايا دائرية أكثر
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 8,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: TextField(
//         onSubmitted: onSearch, // عند البحث
//         decoration: InputDecoration(
//           hintText: 'ابحث عن خدمة...',
//           hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
//           prefixIcon: Padding(
//             padding: const EdgeInsets.all(10),
//             child: GestureDetector(
//               onTap: () {
//                 if (onSearch != null) {
//                   onSearch!('');
//                 }
//               },
//               child: Icon(Icons.search, color: Colors.white, size: 24),
//             ),
//           ),
//           suffixIcon: Padding(
//             padding: const EdgeInsets.all(10),
//             child: GestureDetector(
//               onTap: onVoiceSearch,
//               child: Icon(Icons.mic, color: Colors.white, size: 24),
//             ),
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: BorderSide.none,
//           ),
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.2),
//           contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//         ),
//         style: TextStyle(color: Colors.white, fontSize: 16),
//         cursorColor: Colors.white,
//       ),
//     );
//   }
// }
