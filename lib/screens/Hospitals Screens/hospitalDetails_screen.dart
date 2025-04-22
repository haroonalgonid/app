import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../service/Hospital_service.dart';
import 'doctorDetails_screen.dart';

class HospitalDetailsScreen extends StatefulWidget {
  final String hospitalId;

  const HospitalDetailsScreen({super.key, required this.hospitalId});

  @override
  State<HospitalDetailsScreen> createState() => _HospitalDetailsScreenState();
}

class _HospitalDetailsScreenState extends State<HospitalDetailsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  int _currentImageIndex = 0;
  late TabController _tabController;
  bool isFavorite = false;
  Map<String, dynamic>? hospitalDetails;
  bool isLoading = true;
  List<dynamic>? doctorsList;
  bool isLoadingDoctors = false;
  Map<String, dynamic>? reviewsData;
  bool isLoadingReviews = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchHospitalDetails();

    // إضافة مستمع لتغير التبويبات لتحميل البيانات عند الحاجة
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 1 && doctorsList == null) {
          _fetchDoctors();
        } else if (_tabController.index == 2 && reviewsData == null) {
          _fetchReviews();
        }
      }
    });
  }

  Future<void> _fetchHospitalDetails() async {
    if (!await _checkInternetConnection()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا يوجد اتصال بالإنترنت')),
        );
      }
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final details =
          await HospitalService.getHospitalDetails(widget.hospitalId);
      if (details != null && mounted) {
        setState(() {
          hospitalDetails = details;
          isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا توجد بيانات متاحة')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تحميل بيانات المستشفى: $e')),
        );
      }
    }
  }

  Future<void> _fetchDoctors() async {
    if (!await _checkInternetConnection()) {
      if (mounted) {
        Get.snackbar(
          'خطأ في الاتصال',
          'لا يوجد اتصال بالإنترنت',
          icon: const Icon(Icons.wifi_off, color: Colors.red),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
        );
      }
      return;
    }

    setState(() {
      isLoadingDoctors = true;
    });

    try {
      final doctors =
          await HospitalService.getHospitalDoctors(widget.hospitalId);
      if (doctors != null && mounted) {
        setState(() {
          doctorsList = doctors;
          isLoadingDoctors = false;
        });
      } else if (mounted) {
        setState(() {
          isLoadingDoctors = false;
        });
        Get.snackbar(
          'لا توجد بيانات',
          'لا توجد بيانات للأطباء',
          icon: const Icon(Icons.info_outline, color: Colors.blue),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingDoctors = false;
        });
        Get.snackbar(
          'خطأ',
          'فشل في تحميل بيانات الأطباء: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _fetchReviews() async {
    // ... التحقق من الاتصال بالإنترنت

    setState(() => isLoadingReviews = true);

    try {
      final reviews =
          await HospitalService.getHospitalReviews(widget.hospitalId);
      if (mounted) {
        setState(() {
          reviewsData = reviews ?? {"averageRating": 0, "reviewsData": []};
          isLoadingReviews = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingReviews = false;
          reviewsData = {"averageRating": 0, "reviewsData": []};
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تحميل التقييمات: $e')),
        );
      }
    }
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (hospitalDetails == null) {
      return const Scaffold(
        body: Center(child: Text('فشل في تحميل بيانات المستشفى')),
      );
    }

    final List<String> hospitalImages = hospitalDetails?['images'] ??
        [
          'https://picsum.photos/600/400?random=1',
          'https://picsum.photos/600/400?random=2',
          'https://picsum.photos/600/400?random=3',
        ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: Colors.red,
              iconTheme: const IconThemeData(color: Colors.white),
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
                      items: hospitalImages.map((image) {
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
                        children: hospitalImages.asMap().entries.map((entry) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.withOpacity(
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
                                hospitalDetails?['name'] ?? 'اسم المستشفى',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.grey, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      hospitalDetails?['address'] ??
                                          'عنوان المستشفى',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TabBar(
                      controller: _tabController,
                      labelColor: Colors.red,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.red,
                      tabs: const [
                        Tab(text: 'نظرة عامة'),
                        Tab(text: 'الأطباء'),
                        Tab(text: 'المراجعات'),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildOverviewTab(hospitalDetails),
                          _buildDoctorsTab(),
                          _buildReviewsTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic>? hospitalDetails) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'وصف المستشفى',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hospitalDetails?['description'] ?? 'وصف المستشفى',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'المرافق',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: (hospitalDetails?['facilities'] as List<dynamic>? ?? [])
                .map((amenity) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAmenityIcon(amenity),
                      size: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsTab() {
    if (isLoadingDoctors) {
      return const Center(child: CircularProgressIndicator());
    }

    if (doctorsList == null || doctorsList!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد أطباء متاحين حالياً',
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: doctorsList!.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doctor = doctorsList![index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DoctorDetailsScreen(doctorId: doctor['id']),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // معلومات الطبيب
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor['name'] ?? 'دكتور غير معروف',
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[800],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          doctor['specialty'] ?? 'تخصص غير محدد',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.blueGrey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.medical_services,
                                color: Colors.red[400], size: 18),
                            const SizedBox(width: 6),
                            Text(
                              '${doctor['experienceYears'] ?? '0'} سنوات خبرة',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.blueGrey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // أيقونة الانتقال
                  Icon(Icons.chevron_left, color: Colors.blueGrey[300]),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    if (isLoadingReviews) {
      return const Center(child: CircularProgressIndicator());
    }

    final rating = reviewsData?["averageRating"]?.toDouble() ?? 0.0;
    final reviews = reviewsData?["reviewsData"] as List? ?? [];

    return Column(
      children: [
        // Average Rating Section (تظهر فقط إذا كان هناك تقييمات)
        if (reviews.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'تقييم المستشفى',
                  style: GoogleFonts.tajawal(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[800],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '/5',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 28,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                const SizedBox(height: 12),
                Text(
                  'بناءً على ${reviews.length} تقييم${reviews.length > 1 ? 'ات' : ''}',
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 20),

        // Add Review Button (يظهر دائمًا)
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _showAddReviewDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add, size: 20),
                const SizedBox(width: 8),
                Text(
                  'أضف تقييمك',
                  style: GoogleFonts.tajawal(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Reviews List (تظهر فقط إذا كان هناك تقييمات)
        if (reviews.isNotEmpty)
          Expanded(
            child: ListView.separated(
              itemCount: reviews.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.red[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        review['fullName'] ?? 'زائر',
                                        style: GoogleFonts.tajawal(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      RatingBar.builder(
                                        initialRating:
                                            review['rating']?.toDouble() ?? 0.0,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 16,
                                        ignoreGestures: true,
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatReviewDate(review['createdAt']),
                                    style: GoogleFonts.tajawal(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          review['comment'] ?? 'لا يوجد تعليق',
                          style: GoogleFonts.tajawal(
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        else
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.reviews, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد تقييمات متاحة بعد',
                    style: GoogleFonts.tajawal(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'كن أول من يقيّم هذا المستشفى',
                    style: GoogleFonts.tajawal(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _formatReviewDate(String dateString) {
    final date = DateTime.parse(dateString).toLocal();
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return 'منذ $months شهر${months > 1 ? 'ين' : ''}';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return 'منذ $weeks أسبوع${weeks > 1 ? 'ين' : ''}';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم${difference.inDays > 1 ? 'ين' : ''}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة${difference.inHours > 1 ? 'ات' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة${difference.inMinutes > 1 ? 'ات' : ''}';
    } else {
      return 'الآن';
    }
  }

  void _showAddReviewDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double rating = 0;
    String comment = '';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'شاركنا رأيك',
                  style: GoogleFonts.tajawal(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 36,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      rating = rating;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'التعليق',
                  style: GoogleFonts.tajawal(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Form(
                  key: formKey,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'اكتب تعليقك هنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال تعليقك';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      comment = value!;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          'إلغاء',
                          style: GoogleFonts.tajawal(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!await _checkInternetConnection()) {
                            Get.snackbar(
                              'خطأ في الاتصال',
                              'لا يوجد اتصال بالإنترنت',
                              icon: const Icon(Icons.wifi_off, color: Colors.red),
                              snackPosition: SnackPosition.TOP,
                              colorText: Colors.black,
                              duration: const Duration(seconds: 3),
                            );
                            return;
                          }

                          if (rating == 0) {
                            Get.snackbar(
                              'نقص في البيانات',
                              'الرجاء تحديد تقييم',
                              icon:
                                  const Icon(Icons.star_border, color: Colors.amber),
                              snackPosition: SnackPosition.TOP,
                              colorText: Colors.black,
                              duration: const Duration(seconds: 3),
                            );
                            return;
                          }

                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            bool success =
                                await HospitalService.addHospitalReview(
                              hospitalId: widget.hospitalId,
                              rating: rating.toInt(),
                              comment: comment,
                            );

                            if (success) {
                              Get.snackbar(
                                'نجاح',
                                'تم إضافة التقييم بنجاح!',
                                icon: const Icon(Icons.check_circle,
                                    color: Colors.green),
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.black,
                                duration: const Duration(seconds: 3),
                              );
                              Navigator.of(context).pop();
                              await _fetchReviews();
                            } else {
                              Get.snackbar(
                                'خطأ',
                                'يرجى تسجيل الدخول أولاً',
                                icon: const Icon(Icons.error, color: Colors.red),
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.black,
                                duration: const Duration(seconds: 3),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'حفظ التقييم',
                          style: GoogleFonts.tajawal(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
      case 'واي فاي':
        return Icons.wifi;
      case 'tv':
      case 'تلفاز':
        return Icons.tv;
      case 'air conditioning':
      case 'تكييف':
        return Icons.ac_unit;
      case 'mini bar':
      case 'ميني بار':
        return Icons.local_bar;
      default:
        return Icons.check_circle;
    }
  }
}
