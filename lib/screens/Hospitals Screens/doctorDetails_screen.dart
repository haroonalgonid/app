import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../service/Hospital_service.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String doctorId;

  const DoctorDetailsScreen({super.key, required this.doctorId});

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  Map<String, dynamic>? doctorDetails;
  List<Map<String, dynamic>>? doctorSchedules;
  Map<String, dynamic>? doctorReviews;
  bool isLoading = true;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? selectedRating;
  TextEditingController reviewController = TextEditingController();

  // ألوان التطبيق
  final Color primaryColor = const Color(0xFFD32F2F); // أحمر داكن
  final Color secondaryColor = const Color(0xFFFFCDD2); // أحمر فاتح
  final Color accentColor = const Color(0xFFB71C1C); // أحمر غامق
  final Color backgroundColor = const Color(0xFFF5F5F5); // رمادي فاتح
  final Color textColor = const Color(0xFF424242); // رمادي داكن

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
    _fetchDoctorSchedules();
    _fetchDoctorReviews();
  }

  Future<void> _fetchDoctorDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final details = await HospitalService.getDoctorDetails(widget.doctorId);
      if (details != null) {
        setState(() {
          doctorDetails = details;
        });
      } else {
        _showErrorSnackbar('لا توجد بيانات متاحة');
      }
    } catch (e) {
      _showErrorSnackbar('فشل في تحميل بيانات الطبيب: $e');
    }
  }

  Future<void> _fetchDoctorSchedules() async {
    try {
      final schedules = await HospitalService.getDoctorSchedules(widget.doctorId);
      if (schedules != null) {
        setState(() {
          doctorSchedules = schedules;
        });
      } else {
        _showErrorSnackbar('لا توجد أوقات دوام متاحة');
      }
    } catch (e) {
      _showErrorSnackbar('فشل في تحميل أوقات الدوام: $e');
    }
  }

  Future<void> _fetchDoctorReviews() async {
    try {
      final reviews = await HospitalService.getDoctorReviews(widget.doctorId);
      if (reviews != null) {
        setState(() {
          doctorReviews = reviews;
        });
      } else {
        _showErrorSnackbar('لا توجد مراجعات متاحة');
      }
    } catch (e) {
      _showErrorSnackbar('فشل في تحميل المراجعات: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _bookAppointment() async {
    if (selectedDate == null || selectedTime == null) {
      Get.snackbar(
        'تنبيه',
        'الرجاء اختيار التاريخ والوقت',
        icon: Icon(Icons.warning, color: Colors.orange),
        snackPosition: SnackPosition.TOP,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        colorText: Colors.black,
        backgroundColor: Colors.amber[50],
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // إنشاء DateTime من التاريخ والوقت المختارين
    final DateTime appointmentDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // تنسيق التاريخ والوقت بالصيغة المطلوبة "yyyy-MM-ddTHH:mm"
    final String formattedDateTime =
        "${appointmentDateTime.year.toString().padLeft(4, '0')}-"
        "${appointmentDateTime.month.toString().padLeft(2, '0')}-"
        "${appointmentDateTime.day.toString().padLeft(2, '0')}T"
        "${appointmentDateTime.hour.toString().padLeft(2, '0')}:"
        "${appointmentDateTime.minute.toString().padLeft(2, '0')}";

    final String? errorMessage = await HospitalService.bookAppointment(
      doctorId: widget.doctorId,
      dateTime: formattedDateTime,
    );

    if (errorMessage == null) {
      Get.snackbar(
        'نجاح',
        'تم حجز الموعد بنجاح',
        icon: const Icon(Icons.check_circle, color: Colors.green),
        snackPosition: SnackPosition.TOP,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        colorText: Colors.black,
        backgroundColor: Colors.green[50],
        duration: const Duration(seconds: 3),
      );
    } else {
      Get.snackbar(
        'خطأ',
        errorMessage,
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.TOP,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        colorText: Colors.black,
        backgroundColor: Colors.red[50],
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _submitReview() async {
    if (selectedRating == null || reviewController.text.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'الرجاء إدخال التقييم والتعليق',
        icon: const Icon(Icons.warning, color: Colors.orange),
        snackPosition: SnackPosition.TOP,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        colorText: Colors.black,
        backgroundColor: Colors.amber[50],
        duration: const Duration(seconds: 3),
      );
      return;
    }

    bool success = await HospitalService.addDoctorReview(
      doctorId: widget.doctorId,
      rating: selectedRating!,
      comment: reviewController.text,
    );

    if (success) {
      Get.snackbar(
        'نجاح',
        'تم إضافة التقييم بنجاح',
        icon: const Icon(Icons.check_circle, color: Colors.green),
        snackPosition: SnackPosition.TOP,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        colorText: Colors.black,
        backgroundColor: Colors.green[50],
        duration: const Duration(seconds: 3),
      );
      reviewController.clear();
      selectedRating = null;
      _fetchDoctorReviews();
    } else {
      Get.snackbar(
        'خطأ',
        'فشل في إضافة التقييم',
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.TOP,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        colorText: Colors.black,
        backgroundColor: Colors.red[50],
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
              const SizedBox(height: 20),
              Text(
                'جاري تحميل البيانات...',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (doctorDetails == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: primaryColor),
              const SizedBox(height: 20),
              Text(
                'فشل في تحميل بيانات الطبيب',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _fetchDoctorDetails,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          doctorDetails?['name'] ?? 'تفاصيل الطبيب',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الطبيب والمعلومات الأساسية
            _buildDoctorProfileHeader(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // السيرة الذاتية
                  const SizedBox(height: 20),
                  _buildSectionTitle('السيرة الذاتية', Icons.person_outline),
                  const SizedBox(height: 10),
                  _buildBioCard(),

                  // التقييمات
                  const SizedBox(height: 25),
                  _buildSectionTitle('التقييم العام', Icons.star_outline),
                  const SizedBox(height: 10),
                  _buildRatingOverviewCard(),

                  // أوقات الدوام
                  const SizedBox(height: 25),
                  _buildSectionTitle('أوقات الدوام', Icons.calendar_month_outlined),
                  const SizedBox(height: 10),
                  _buildSchedulesList(),

                  // حجز موعد
                  const SizedBox(height: 25),
                  _buildSectionTitle('حجز موعد', Icons.schedule_outlined),
                  const SizedBox(height: 10),
                  _buildAppointmentBookingCard(),

                  // المراجعات
                  const SizedBox(height: 25),
                  _buildSectionTitle('المراجعات', Icons.comment_outlined),
                  const SizedBox(height: 10),
                  _buildReviewsList(),

                  // إضافة تقييم
                  const SizedBox(height: 25),
                  _buildSectionTitle('إضافة تقييم', Icons.rate_review_outlined),
                  const SizedBox(height: 10),
                  _buildAddReviewCard(),
                  
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // صورة الطبيب والمعلومات الأساسية
  Widget _buildDoctorProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, bottom: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // صورة الطبيب
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.network(
                doctorDetails?['image'] ?? 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: secondaryColor,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 15),
          
          // اسم الطبيب
          Text(
            doctorDetails?['name'] ?? 'اسم الطبيب',
            style: GoogleFonts.cairo(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 5),
          
          // التخصص
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              doctorDetails?['specialty'] ?? 'التخصص',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // معلومات إضافية
         // في دالة _buildDoctorProfileHeader، قم بتعديل جزء معلومات إضافية كالتالي:
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 25),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildInfoItem(
        Icons.work_outline,
        '${doctorDetails?['experienceYears'] ?? '؟'} سنة',
        'خبرة',
      ),
      _buildVerticalDivider(),
      _buildInfoItem(
        Icons.medical_services,
        doctorDetails?['specialty'] ?? '؟؟؟',
        'تخصص',
      ),
      _buildVerticalDivider(),
      _buildInfoItem(
        Icons.star,
        '${doctorReviews?['averageRating']?.toStringAsFixed(1) ?? '0.0'}',
        'تقييم',
      ),
    ],
  ),
),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[300],
    );
  }

  Widget _buildInfoItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 22,
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // السيرة الذاتية
  Widget _buildBioCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          doctorDetails?['bio'] ?? 'لا يوجد وصف',
          style: GoogleFonts.cairo(
            fontSize: 15,
            height: 1.5,
            color: textColor,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  // بطاقة التقييم العام
  Widget _buildRatingOverviewCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '${doctorReviews?['averageRating']?.toStringAsFixed(1) ?? '0.0'}',
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // نجوم التقييم
                  Row(
                    children: List.generate(5, (index) {
                      double rating = doctorReviews?['averageRating'] ?? 0.0;
                      return Icon(
                        index < rating.floor()
                            ? Icons.star
                            : (index < rating ? Icons.star_half : Icons.star_border),
                        color: Colors.amber,
                        size: 20,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${doctorReviews?['totalReviews'] ?? 0} تقييم',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // جدول المواعيد
Widget _buildSchedulesList() {
  if (doctorSchedules == null || doctorSchedules!.isEmpty) {
    return _buildEmptyState('لا توجد أوقات دوام متاحة', Icons.calendar_today);
  }
  
  return Card(
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(
        color: Colors.grey[200]!,
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: doctorSchedules!.map((schedule) {
          // دالة لتنسيق التاريخ بدون أصفار
String formatDate(String dateStr) {
  try {
    // معالجة التواريخ التي تحتوي على T و .000Z
    if (dateStr.contains('T')) {
      dateStr = dateStr.split('T')[0];
    }
    
    // إزالة الأجزاء الزمنية إذا وجدت
    dateStr = dateStr.split(' ')[0];
    
    // إزالة الأصفار الزائدة من أجزاء التاريخ
    final parts = dateStr.split('-');
    final year = parts[0];
    final month = parts[1].startsWith('0') ? parts[1].substring(1) : parts[1];
    final day = parts[2].startsWith('0') ? parts[2].substring(1) : parts[2];
    
    // إنشاء تاريخ جديد بدون أصفار زائدة
    final cleanedDate = '$year-$month-$day';
    DateTime date = DateTime.parse(cleanedDate);
    
    // تنسيق التاريخ بالشكل المطلوب (بدون أصفار)
    return DateFormat('yyyy/M/d', 'ar').format(date);
  } catch (e) {
    print('Error formatting date: $e');
    return dateStr; // في حالة الخطأ، إرجاع التاريخ كما هو
  }
}

          // دالة لتنسيق الوقت
          String formatTime(String timeStr) {
            try {
              final parts = timeStr.split(':');
              final hour = parts[0].startsWith('0') ? parts[0].substring(1) : parts[0];
              final minute = parts[1];
              
              TimeOfDay time = TimeOfDay(
                hour: int.parse(hour),
                minute: int.parse(minute),
              );
              return time.format(context);
            } catch (e) {
              return timeStr;
            }
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: secondaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Row(
  children: [
    Icon(Icons.date_range, size: 18, color: primaryColor),
    const SizedBox(width: 8),
    Flexible(
      child: Text(
        'من ${formatDate(schedule['startDate'])} إلى ${formatDate(schedule['endDate'])}',
        style: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    ),
  ],
),
                const SizedBox(height: 8),
                
                // عرض أوقات الدوام اليومية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 18, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          '${formatTime(schedule['startTime'])} - ${formatTime(schedule['endTime'])}',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.timer, size: 18, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          '${schedule['slotDuration']} دقيقة',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // عرض أيام الدوام (إذا كانت متوفرة)
                if (schedule['days'] != null && schedule['days'].isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_view_week, size: 18, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'أيام الدوام: ${schedule['days'].join('، ')}',
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    ),
  );
}

  // بطاقة حجز موعد
  Widget _buildAppointmentBookingCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'اختر موعدك المناسب',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: secondaryColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 18, color: primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              selectedDate == null
                                  ? 'اختر التاريخ'
                                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: secondaryColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.access_time, size: 18, color: primaryColor),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              selectedTime == null
                                  ? 'اختر الوقت'
                                  : selectedTime!.format(context),
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'تأكيد الحجز',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // قائمة المراجعات
  Widget _buildReviewsList() {
    if (doctorReviews == null || 
        doctorReviews!['reviewsData'] == null || 
        doctorReviews!['reviewsData'].isEmpty) {
      return _buildEmptyState('لا توجد مراجعات متاحة', Icons.comment);
    }
    
    return Column(
      children: doctorReviews!['reviewsData'].map<Widget>((review) {
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              (review['fullName'] ?? 'مستخدم')[0].toUpperCase(),
                              style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          review['fullName'] ?? 'مستخدم مجهول',
                          style: GoogleFonts.cairo(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${review['rating']}',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    review['comment'] ?? 'لا يوجد تعليق',
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      height: 1.4,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.parse(review['createdAt'])),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // بطاقة إضافة تقييم
  Widget _buildAddReviewCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'شارك تجربتك مع الطبيب',
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 15),
            // اختيار التقييم
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'التقييم:',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<int>(
                    value: selectedRating,
                    hint: Text(
                      'اختر التقييم',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    items: List.generate(5, (index) => index + 1)
                        .map((rating) => DropdownMenuItem<int>(
                              value: rating,
                              child: Row(
                                children: List.generate(
                                  rating,
                                  (i) => const Icon(Icons.star, size: 18, color: Colors.amber),
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRating = value;
                      });
                    },
                    underline: const SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: primaryColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            // حقل التعليق
            TextField(
              controller: reviewController,
              decoration: InputDecoration(
                labelText: 'اكتب تعليقك هنا',
                labelStyle: GoogleFonts.cairo(
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              maxLines: 3,
              style: GoogleFonts.cairo(),
              textAlign: TextAlign.right,
              // textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 15),
            // زر الإرسال
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'إرسال التقييم',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // عنوان القسم
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 22, color: primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  // حالة العنصر الفارغ
  Widget _buildEmptyState(String text, IconData icon) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              text,
              style: GoogleFonts.cairo(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}