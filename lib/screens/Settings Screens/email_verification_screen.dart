// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:st/theme/color.dart';

// import 'createUser_screen.dart';

// class EmailVerificationScreen extends StatelessWidget {
//   final TextEditingController _codeController = TextEditingController();

//   EmailVerificationScreen({super.key});

//   void _verifyCode() {
//     final String code = _codeController.text;

//     if (code.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter the code',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.red,
//         colorText: AppColors.background,
//       );
//     } else {
//       // Here you can add the logic to verify the code
//       print('Entered code: $code');

//       // Success notification
//       Get.snackbar(
//         'Success',
//         'Code verified successfully',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: AppColors.successColor,
//         colorText: AppColors.background,
//       );

//       // Navigate to the next screen
//       // Get.offAll(() => HomeScreen());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: AppColors.background, // Fixed color
//         foregroundColor: AppColors.primaryColor, // Fixed color
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back,
//               color: AppColors.primaryColor), // Fixed color
//           onPressed: () {
//              Get.to(() => UserRegistrationScreen());
//           },
//         ),
//       ),
//       body: Directionality(
//         textDirection: TextDirection.ltr, // Set text direction to left-to-right
//         child: Container(
//           color: AppColors.background, // Fixed color
//           child: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Enter the code sent to your email',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: AppColors.textPrimary, // Fixed color
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   // Code input field
//                   TextFormField(
//                     controller: _codeController,
//                     decoration: InputDecoration(
//                       labelText: 'Code',
//                       prefixIcon: const Icon(Icons.code,
//                           color: AppColors.primaryColor), // Fixed color
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide:
//                             const BorderSide(color: AppColors.grey), // Fixed color
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(
//                             color: AppColors.primaryColor,
//                             width: 2), // Fixed color
//                       ),
//                       filled: true,
//                       fillColor: AppColors.background, // Fixed color
//                     ),
//                     keyboardType: TextInputType.number,
//                   ),
//                   const SizedBox(height: 30),
//                   // Verify button
//                   Container(
//                     width: double.infinity,
//                     height: 55,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: [
//                         BoxShadow(
//                           color: AppColors.primaryColor
//                               .withOpacity(0.3), // Fixed color
//                           blurRadius: 8,
//                           offset: const Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: ElevatedButton(
//                       onPressed: _verifyCode,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primaryColor, // Fixed color
//                         foregroundColor: AppColors.background, // Fixed color
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 15),
//                       ),
//                       child: const Text(
//                         'Verify',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
