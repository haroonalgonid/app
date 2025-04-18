
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../service/CarRentalService.dart';
import '../../theme/color.dart';
// import 'car_companies_screen.dart';
// import 'car_details_screen.dart';
import 'CarDetailsScreen.dart';
import 'transportationHome_screen.dart';

class Car {
  final String id;
  final String rentalCompanyId;
  final String rentalCompanyName;
  final String rentalCompanyAddress;
  final String make;
  final String model;
  final int year;
  final String type;
  final double pricePerDay;
  final int seats;
  final String transmission;
  final String fuelType;
  final int mileage;
  final List<String> features;
  final List<String> images;
  final bool isAvailable;
  final String plateNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  Car({
    required this.id,
    required this.rentalCompanyId,
    required this.rentalCompanyName,
    required this.rentalCompanyAddress,
    required this.make,
    required this.model,
    required this.year,
    required this.type,
    required this.pricePerDay,
    required this.seats,
    required this.transmission,
    required this.fuelType,
    required this.mileage,
    required this.features,
    required this.images,
    required this.isAvailable,
    required this.plateNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'] ?? '',
      rentalCompanyId: map['rentalCompanyId'] ?? '',
      rentalCompanyName: map['rentalCompanyName'] ?? '',
      rentalCompanyAddress: map['rentalCompanyAddress'] ?? '',
      make: map['make'] ?? '',
      model: map['model'] ?? '',
      year: map['year'] ?? 0,
      type: map['type'] ?? '',
      pricePerDay: (map['pricePerDay'] ?? 0).toDouble(),
      seats: map['seats'] ?? 0,
      transmission: map['transmission'] ?? '',
      fuelType: map['fuelType'] ?? '',
      mileage: map['mileage'] ?? 0,
      features: List<String>.from(map['features'] ?? []),
      images: List<String>.from(map['images'] ?? []),
      isAvailable: map['isAvailable'] ?? false,
      plateNumber: map['plateNumber'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toString()),
    );
  }
}

class Review {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;
  Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

class CarCompanyDetailsScreen extends StatefulWidget {
  final CarCompany company;

  const CarCompanyDetailsScreen({super.key, required this.company});

  @override
  State<CarCompanyDetailsScreen> createState() => _CarCompanyDetailsScreenState();
}

class _CarCompanyDetailsScreenState extends State<CarCompanyDetailsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentImageIndex = 0;
  late TabController _tabController;
  // bool isFavorite = false;
  List<Review> reviews = [];
  List<Car>? cars; // لتخزين السيارات بعد جلبها

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // جلب السيارات والمراجعات عند بدء الشاشة
    _fetchCars();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final reviewsData = await CarRentalService.getCarRentalReviews(widget.company.id);
      if (reviewsData != null) {
        setState(() {
          reviews = reviewsData
              .map((reviewData) => Review(
                    userName: reviewData['fullName'] ?? 'غير معروف',
                    rating: reviewData['rating']?.toDouble() ?? 0.0,
                    comment: reviewData['comment'] ?? '',
                    date: DateTime.parse(
                        reviewData['createdAt'] ?? DateTime.now().toString()),
                  ))
              .toList();
        });
      } else {
        print("No reviews found for this company.");
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() {
        reviews = [];
      });
    }
  }

  Future<void> _showAddReviewDialog() async {
    double? rating;
    String comment = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إضافة تقييم', style: GoogleFonts.cairo()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (newRating) {
                rating = newRating;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'تعليقك',
                labelStyle: GoogleFonts.cairo(),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) {
                comment = value;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
            ),
            onPressed: () async {
              if (rating == null || comment.isEmpty) {
                Get.snackbar(
                  'خطأ',
                  'يرجى إدخال التقييم والتعليق',
                  icon: Icon(Icons.error, color: Colors.red),
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.black,
                  duration: Duration(seconds: 3),
                );
                return;
              }

              final success = await CarRentalService.addCarRentalReview(
                widget.company.id,
                rating!.toInt(),
                comment,
              );

              if (success) {
                _fetchReviews();
                Navigator.pop(context);
                Get.snackbar(
                  'تم إضافة التقييم بنجاح',
                  'تم إضافة تقييمك للشركة بنجاح.',
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.black,
                  duration: Duration(seconds: 3),
                );
              } else {
                Get.snackbar(
                  'خطأ',
                  'يرجى تسجيل الدخول أولاً',
                  icon: Icon(Icons.warning, color: Colors.blue),
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.black,
                  duration: Duration(seconds: 3),
                );
              }
            },
            child: Text('إرسال', style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

Future<void> _fetchCars() async {
  try {
    final fetchedCars = await CarRentalService.getRentalCars(widget.company.id);
    print("Fetched Cars: $fetchedCars");
    
    if (fetchedCars != null) {
      setState(() {
        cars = fetchedCars.map((carData) => Car(
          id: carData['id'] ?? '',
          rentalCompanyId: carData['rentalCompanyId'] ?? '',
          rentalCompanyName: carData['rentalCompanyName'] ?? widget.company.name,
          rentalCompanyAddress: carData['rentalCompanyAddress'] ?? widget.company.location,
          make: carData['make'] ?? '',
          model: carData['model'] ?? '',
          year: carData['year'] ?? 0,
          type: carData['type'] ?? '',
          pricePerDay: (carData['pricePerDay'] ?? 0).toDouble(),
          seats: carData['seats'] ?? 0,
          transmission: carData['transmission'] ?? '',
          fuelType: carData['fuelType'] ?? '',
          mileage: carData['mileage'] ?? 0,
          features: List<String>.from(carData['features'] ?? []),
          images: List<String>.from(carData['images'] ?? []),
          isAvailable: carData['isAvailable'] ?? false,
          plateNumber: carData['plateNumber'] ?? '',
          createdAt: DateTime.parse(carData['createdAt'] ?? DateTime.now().toString()),
          updatedAt: DateTime.parse(carData['updatedAt'] ?? DateTime.now().toString()),
        )).toList();
      });
    } else {
      print("No cars found for this company.");
      setState(() {
        cars = [];
      });
    }
  } catch (e) {
    print("Error fetching cars: $e");
    setState(() {
      cars = [];
    });
  }
}

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<String> companyImages = widget.company.images.isNotEmpty
        ? widget.company.images
        : [
            widget.company.image,
            'https://picsum.photos/600/400?random=1',
            'https://picsum.photos/600/400?random=2',
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
                      items: companyImages.map((image) {
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
                        children: companyImages.asMap().entries.map((entry) {
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
                                widget.company.name,
                                style: GoogleFonts.cairo(
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
                                      widget.company.location,
                                      style: GoogleFonts.cairo(
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
                        // IconButton(
                        //   icon: Icon(
                        //     isFavorite ? Icons.favorite : Icons.favorite_border,
                        //     color: isFavorite ? Colors.red : Colors.grey,
                        //   ),
                        //   onPressed: () {
                        //     setState(() {
                        //       isFavorite = !isFavorite;
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.orange,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.orange,
                      tabs: const [
                        Tab(text: 'نظرة عامة'),
                        Tab(text: 'السيارات المتاحة'),
                        Tab(text: 'المراجعات'),
                      ],
                    ),
                    SizedBox(
                      height: 500,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // نظرة عامة
                          _buildOverviewTab(widget.company),
                          // السيارات
                          cars == null
                              ? Center(child: CircularProgressIndicator())
                              : cars!.isEmpty
                                  ? Center(
                                      child: Text(
                                        'لا توجد سيارات متاحة.',
                                        style: GoogleFonts.cairo(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    )
                                  : _buildCarsTab(cars!),
                          // المراجعات
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

  Widget _buildOverviewTab(CarCompany company) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'وصف الشركة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            company.description.isNotEmpty
                ? company.description
                : "لا يوجد وصف متاح",
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'الخدمات المقدمة',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: company.services.map((service) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getServiceIcon(service),
                      size: 20,
                      color: AppColors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      service,
                      style: GoogleFonts.cairo(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 8),
              Text(
                'التقييم: ${company.rating}',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildCarsTab(List<Car> cars) {
  return ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: cars.length,
    itemBuilder: (context, index) {
      final car = cars[index];
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarDetailsScreen(car: car),
            ),
          );
        },
        child: Card(
          margin: const EdgeInsets.only(bottom: 20),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: car.images.isNotEmpty 
                  ? Image.network(
                      car.images[0],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: Icon(Icons.car_rental, size: 50, color: Colors.grey),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${car.make} ${car.model}',
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${car.pricePerDay} ر.س/يوم',
                          style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text('السنة: ${car.year}',
                            style: GoogleFonts.cairo(color: Colors.grey)),
                        const SizedBox(width: 15),
                        Icon(Icons.people, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text('${car.seats} مقاعد',
                            style: GoogleFonts.cairo(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.settings, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text('ناقل الحركة: ${car.transmission}',
                            style: GoogleFonts.cairo(color: Colors.grey)),
                        const SizedBox(width: 15),
                        Icon(Icons.local_gas_station, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text('نوع الوقود: ${car.fuelType}',
                            style: GoogleFonts.cairo(color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: car.features.map((feature) {
                        return Chip(
                          label: Text(
                            feature,
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
      );
    },
  );
}

  Widget _buildReviewsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            onPressed: () => _showAddReviewDialog(),
            icon: Icon(Icons.add, color: Colors.white),
            label: Text(
              'إضافة تقييم',
              style: GoogleFonts.cairo(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ),

        if (reviews.isEmpty)
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'لا توجد مراجعات بعد. كن أول من يقيم هذه الشركة!',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 15, left: 16, right: 16),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  AppColors.orange.withOpacity(0.2),
                              child:
                                  Icon(Icons.person, color: AppColors.orange),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.userName,
                                    style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${review.date.day}/${review.date.month}/${review.date.year}',
                                    style: GoogleFonts.cairo(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RatingBarIndicator(
                              rating: review.rating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          review.comment,
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  IconData _getServiceIcon(String service) {
    switch (service.toLowerCase()) {
      case 'توصيل':
        return Icons.delivery_dining;
      case 'سائق':
        return Icons.person;
      case 'تأمين':
        return Icons.security;
      case 'وقود مجاني':
        return Icons.local_gas_station;
      case 'صيانة':
        return Icons.build;
      case 'غسيل':
        return Icons.local_car_wash;
      default:
        return Icons.directions_car;
    }
  }
}