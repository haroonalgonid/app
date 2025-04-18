// import 'package:flutter/material.dart';

// class EnhancedServiceIcon extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   final VoidCallback onTap;

//   const EnhancedServiceIcon({super.key, 
//     required this.icon,
//     required this.label,
//     required this.color,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         double iconSize = constraints.maxWidth * 0.3;
        
//         return Material(
//           elevation: 4,
//           borderRadius: BorderRadius.circular(15),
//           child: InkWell(
//             onTap: onTap,
//             borderRadius: BorderRadius.circular(15),
//             splashColor: color.withOpacity(0.2),
//             highlightColor: color.withOpacity(0.1),
//             child: Container(
//               padding: EdgeInsets.all(constraints.maxWidth * 0.1),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     padding: EdgeInsets.all(constraints.maxWidth * 0.08),
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.1),
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(icon, size: iconSize, color: color),
//                   ),
//                   SizedBox(height: constraints.maxHeight * 0.08),
//                   Text(
//                     label,
//                     style: TextStyle(
//                       fontSize: constraints.maxWidth * 0.12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                       height: 1.2,
//                     ),
//                     textAlign: TextAlign.center,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }