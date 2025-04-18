

// Widget _buildCategories() {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.symmetric(vertical: 20),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         children: [
//           _buildCategoryChip('All', Icons.hotel),
//           _buildCategoryChip('Luxury', Icons.star),
//           _buildCategoryChip('Business', Icons.business),
//           _buildCategoryChip('Resort', Icons.beach_access),
//           _buildCategoryChip('Spa', Icons.spa),
//         ],
//       ),
//     );
//   }

// Widget _buildCategoryChip(String label, IconData icon) {
//     final isSelected = _selectedFilter == label;
//     return Padding(
//       padding: const EdgeInsets.only(right: 10),
//       child: FilterChip(
//         selected: isSelected,
//         label: Row(
//           children: [
//             Icon(
//               icon,
//               size: 16,
//               color: isSelected ? Colors.white : Colors.grey,
//             ),
//             const SizedBox(width: 8),
//             Text(label),
//           ],
//         ),
//         backgroundColor: Colors.white,
//         selectedColor: Colors.green, // تغيير اللون المحدد إلى الأخضر
//         labelStyle: TextStyle(
//           color: isSelected ? Colors.white : Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//         onSelected: (bool selected) {
//           setState(() {
//             _selectedFilter = selected ? label : 'All';
//           });
//         },
//         elevation: 2,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       ),
//     );
//   }
