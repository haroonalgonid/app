import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../service/HotelService.dart';
import '../../theme/color.dart';
import 'hotelDetails_screen.dart';

class RoomDetailsScreen extends StatefulWidget {
  final Room room;

  const RoomDetailsScreen({super.key, required this.room});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  final TextEditingController _checkInController = TextEditingController();
  final TextEditingController _checkOutController = TextEditingController();
  int currentPage = 0;

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    super.dispose();
  }

  Future<void> _selectCheckInDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != checkInDate) {
      setState(() {
        checkInDate = picked;
        _checkInController.text = "${picked.day}/${picked.month}/${picked.year}";
        if (checkOutDate != null && checkOutDate!.isBefore(picked)) {
          checkOutDate = null;
          _checkOutController.clear();
        }
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الرجاء تحديد تاريخ الدخول أولاً', style: GoogleFonts.cairo())),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate!.add(const Duration(days: 1)),
      firstDate: checkInDate!.add(const Duration(days: 1)),
      lastDate: checkInDate!.add(const Duration(days: 365)),
    );
    if (picked != null && picked != checkOutDate) {
      setState(() {
        checkOutDate = picked;
        _checkOutController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

Future<void> _bookRoom() async {
  if (checkInDate == null || checkOutDate == null) {
    // Show error message if dates are not selected
    Get.snackbar(
      'الرجاء تحديد تاريخي الدخول والخروج',
      '',
      icon: Icon(Icons.warning, color: Colors.blue), // Change to blue for warning
      snackPosition: SnackPosition.TOP,
      colorText: Colors.black,
      duration: Duration(seconds: 3),
    );
    return;
  }

  try {
    final bookingResult = await HotelService.bookRoom(
      widget.room.id,
      checkInDate!.toIso8601String().split('T')[0],
      checkOutDate!.toIso8601String().split('T')[0],
    );

    if (bookingResult != null) {
      // Show success message if booking is successful
      Get.snackbar(
        'تم الحجز بنجاح!',
        '',
        icon: Icon(Icons.check_circle, color: Colors.green), // Success icon and color
        snackPosition: SnackPosition.TOP,
        colorText: Colors.black,
        duration: Duration(seconds: 3),
      );
    } else {
      // Show error message if user is not logged in
      Get.snackbar(
        'يرجاء تسجيل الدخول أولا',
        '',
        icon: Icon(Icons.warning, color: Colors.blue), // Error warning icon and color
        snackPosition: SnackPosition.TOP,
        colorText: Colors.black,
        duration: Duration(seconds: 3),
      );
    }
  } catch (e) {
    // Show error message for any exception
    Get.snackbar(
      'خطأ',
      e.toString(),
      icon: Icon(Icons.error, color: Colors.red), // Error icon and color
      snackPosition: SnackPosition.TOP,
      colorText: Colors.black,
      duration: Duration(seconds: 3),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'تفاصيل الغرفة',
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عرض صور الغرفة بشكل سلايدر
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        SizedBox(
                          height: 300,
                          child: PageView.builder(
                            itemCount: widget.room.images.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Image.network(
                                widget.room.images[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${currentPage + 1}/${widget.room.images.length}',
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // اسم الغرفة
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.room.name,
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // السعر
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '\$${widget.room.price}/ليلة',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange,
                        ),
                      ),
                    ),

                    // حقول تاريخ الحجز
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تواريخ الحجز',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // حقل تاريخ الدخول
                          TextFormField(
                            controller: _checkInController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'تاريخ الدخول',
                              labelStyle: GoogleFonts.cairo(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: Icon(Icons.calendar_today, color: AppColors.orange),
                            ),
                            onTap: _selectCheckInDate,
                          ),
                          const SizedBox(height: 16),
                          // حقل تاريخ الخروج
                          TextFormField(
                            controller: _checkOutController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'تاريخ الخروج',
                              labelStyle: GoogleFonts.cairo(),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: Icon(Icons.calendar_today, color: AppColors.orange),
                            ),
                            onTap: _selectCheckOutDate,
                          ),
                        ],
                      ),
                    ),

                    // الوصف
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        widget.room.description.isNotEmpty ? widget.room.description : "لا يوجد وصف متاح",
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    // التفاصيل الإضافية
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'التفاصيل',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildDetailRow('عدد الأسرّة', '${widget.room.bedCount}'),
                          _buildDetailRow('عدد الغرف الفرعية', '${widget.room.suiteRoomCount}'),
                          _buildDetailRow('الحجم', '${widget.room.size} م²'),
                          _buildDetailRow('حالة التوفر', widget.room.availability ? 'متاح' : 'غير متاح'),
                        ],
                      ),
                    ),

                    // المرافق
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'المرافق',
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.room.amenities.map((amenity) {
                              return Chip(
                                label: Text(
                                  amenity,
                                  style: GoogleFonts.cairo(color: AppColors.orange),
                                ),
                                backgroundColor: AppColors.orange.withOpacity(0.1),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // زر الحجز في الجزء السفلي
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _bookRoom,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'احجز الآن',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لبناء صفوف التفاصيل
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}