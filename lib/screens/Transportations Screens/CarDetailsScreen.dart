import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../service/CarRentalService.dart';
import '../../theme/color.dart';
import 'CarCompanyDetailsScreen.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class CarDetailsScreen extends StatefulWidget {
  final Car car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  int _currentImageIndex = 0;
  bool isFavorite = false;
  DateTime? pickupDate;
  DateTime? returnDate;
  String pickupLocation = '';
  String returnLocation = '';
  String driverLicenseNumber = '';
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectPickupDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != pickupDate) {
      setState(() {
        pickupDate = picked;
      });
    }
  }

  Future<void> _selectReturnDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: pickupDate ?? DateTime.now(),
      firstDate: pickupDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != returnDate) {
      setState(() {
        returnDate = picked;
      });
    }
  }

  Future<void> _bookCar() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (pickupDate == null || returnDate == null) {
        Get.snackbar(
          'خطأ',
          'الرجاء تحديد تاريخ الاستلام والعودة',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final formattedPickupDate = DateFormat('yyyy-MM-dd').format(pickupDate!);
      final formattedReturnDate = DateFormat('yyyy-MM-dd').format(returnDate!);

      final result = await CarRentalService.bookCar(
        carId: widget.car.id,
        pickupDate: formattedPickupDate,
        returnDate: formattedReturnDate,
        pickupLocation: pickupLocation,
        returnLocation: returnLocation,
        driverLicenseNumber: driverLicenseNumber,
      );

      if (result != null) {
        Get.snackbar(
          'تم الحجز بنجاح',
          'تم حجز ${widget.car.make} ${widget.car.model} بنجاح',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطأ في الحجز',
          'فشل في حجز السيارة، يرجى المحاولة مرة أخرى',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.orange,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 400,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        viewportFraction: 1.0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                      items: widget.car.images.map((image) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.car.images.asMap().entries.map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(
                                _currentImageIndex == entry.key ? 0.9 : 0.4,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              // actions: [
              //   IconButton(
              //     icon: Icon(
              //       isFavorite ? Icons.favorite : Icons.favorite_border,
              //       color: isFavorite ? Colors.red : Colors.white,
              //     ),
              //     onPressed: () {
              //       setState(() {
              //         isFavorite = !isFavorite;
              //       });
              //     },
              //   ),
              // ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.car.make} ${widget.car.model}',
                                style: GoogleFonts.cairo(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'سنة الصنع: ${widget.car.year}',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${widget.car.pricePerDay} ر.س/يوم',
                              style: GoogleFonts.cairo(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.orange,
                              ),
                            ),
                            Text(
                              widget.car.isAvailable ? 'متاحة' : 'غير متاحة',
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                color: widget.car.isAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // معلومات أساسية عن السيارة
                    _buildInfoSection(),
                    
                    const SizedBox(height: 20),
                    
                    // تفاصيل التقنية
                    _buildTechSpecsSection(),
                    
                    const SizedBox(height: 20),
                    
                    // مميزات السيارة
                    _buildFeaturesSection(),
                    
                    const SizedBox(height: 20),
                    
                    // معلومات الشركة المؤجرة
                    _buildCompanyInfoSection(),
                    
                    const SizedBox(height: 30),
                    
                    // نموذج الحجز
                    _buildReservationForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل الحجز',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          
          // تاريخ الاستلام
          ListTile(
            title: Text(
              'تاريخ الاستلام',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              pickupDate != null 
                ? DateFormat('yyyy-MM-dd').format(pickupDate!)
                : 'اختر تاريخ الاستلام',
            ),
            trailing: Icon(Icons.calendar_today, color: AppColors.orange),
            onTap: () => _selectPickupDate(context),
          ),
          
          // تاريخ العودة
          ListTile(
            title: Text(
              'تاريخ العودة',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              returnDate != null 
                ? DateFormat('yyyy-MM-dd').format(returnDate!)
                : 'اختر تاريخ العودة',
            ),
            trailing: Icon(Icons.calendar_today, color: AppColors.orange),
            onTap: () => _selectReturnDate(context),
          ),
          
          // مكان الاستلام
          TextFormField(
            decoration: InputDecoration(
              labelText: 'مكان الاستلام',
              prefixIcon: Icon(Icons.location_on, color: AppColors.orange),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال مكان الاستلام';
              }
              return null;
            },
            onSaved: (value) => pickupLocation = value!,
          ),
          const SizedBox(height: 15),
          
          // مكان العودة
          TextFormField(
            decoration: InputDecoration(
              labelText: 'مكان العودة',
              prefixIcon: Icon(Icons.location_on, color: AppColors.orange),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال مكان العودة';
              }
              return null;
            },
            onSaved: (value) => returnLocation = value!,
          ),
          const SizedBox(height: 15),
          
          // رقم رخصة القيادة
          TextFormField(
            decoration: InputDecoration(
              labelText: 'رقم رخصة القيادة',
              prefixIcon: Icon(Icons.credit_card, color: AppColors.orange),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال رقم رخصة القيادة';
              }
              return null;
            },
            onSaved: (value) => driverLicenseNumber = value!,
          ),
          const SizedBox(height: 25),
          
          // زر الحجز
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _bookCar,
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
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات السيارة',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow('نوع السيارة', widget.car.type),
              _buildTableRow('عدد المقاعد', '${widget.car.seats}'),
              _buildTableRow('رقم اللوحة', widget.car.plateNumber),
              _buildTableRow('المسافة المقطوعة', '${widget.car.mileage} كم'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechSpecsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المواصفات الفنية',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow('ناقل الحركة', widget.car.transmission),
              _buildTableRow('نوع الوقود', widget.car.fuelType),
              _buildTableRow('تاريخ الإضافة', 
                '${widget.car.createdAt.day}/${widget.car.createdAt.month}/${widget.car.createdAt.year}'),
              _buildTableRow('آخر تحديث', 
                '${widget.car.updatedAt.day}/${widget.car.updatedAt.month}/${widget.car.updatedAt.year}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مميزات السيارة',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: widget.car.features.map((feature) {
            return Chip(
              label: Text(
                feature,
                style: GoogleFonts.cairo(color: Colors.white),
              ),
              backgroundColor: AppColors.orange,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCompanyInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'معلومات الشركة المؤجرة',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.business, color: AppColors.orange),
          ),
          title: Text(
            widget.car.rentalCompanyName,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            widget.car.rentalCompanyAddress,
            style: GoogleFonts.cairo(),
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: GoogleFonts.cairo(),
          ),
        ),
      ],
    );
  }
}