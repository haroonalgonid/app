import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../service/restaurants_service.dart';
import '../../theme/color.dart';
import 'menuItem_detail_screen.dart';
import 'restaurant_screen.dart';

class MenuItem {
  final String id;
  final String restaurantId; // يجب أن يكون restaurantId بدلاً من restaurant
  final String name;
  final String description;
  final double price;
  final String category;
  final String image;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    required this.isAvailable,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['_id']?.toString() ?? '',
      restaurantId: json['restaurant']?.toString() ?? '', // تخزين ID فقط
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      isAvailable: json['isAvailable'] is bool ? json['isAvailable'] : false,
    );
  }
}

class Review {
  final String fullName;
  final String comment;
  final int rating;
  final String createdAt;

  Review({
    required this.fullName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      fullName: json['user']['fullName'] ?? 'Unknown',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class RestaurantDetailScreen extends StatefulWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  late TabController _tabController;
  List<MenuItem> menuItems = []; // لتخزين قائمة الوجبات
  List<Review> reviews = []; // لتخزين قائمة التقييمات
  bool isLoadingMenu = true; // لتحديد حالة تحميل القائمة
  bool isLoadingReviews = true; // لتحديد حالة تحميل التقييمات

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchMenuItems(); // استدعاء الدالة لجلب قائمة الوجبات
    _fetchReviews(); // استدعاء الدالة لجلب التقييمات
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMenuItems() async {
    try {
      final fetchedMenuItems =
          await RestaurantApi.fetchMenuItems(widget.restaurant.id);
      setState(() {
        menuItems = fetchedMenuItems; // تحديث قائمة الوجبات
        isLoadingMenu = false; // إيقاف حالة التحميل
      });
    } catch (e) {
      setState(() {
        isLoadingMenu = false; // إيقاف حالة التحميل في حالة حدوث خطأ
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(' $e')),
      // );
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
              border: OutlineInputBorder(), // إضافة حدود للحقل
            ),
            maxLines: 3, // السماح بكتابة تعليق طويل
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
            backgroundColor: Colors.green, // لون الزر البرتقالي
          ),
          onPressed: () async {
            if (rating == null || comment.isEmpty) {
              Get.snackbar(
                'خطأ',
                'يرجى إدخال التقييم والتعليق',
                icon: Icon(Icons.warning, color: Colors.red),
                snackPosition: SnackPosition.TOP,
                colorText: Colors.black,
                duration: Duration(seconds: 3),
              );
              return;
            }

            try {
              final success = await RestaurantApi.addRestaurantReview(
                widget.restaurant.id,
                rating!.toInt(),
                comment,
              );

              if (success) {
                _fetchReviews(); // تحديث قائمة المراجعات بعد الإضافة
                Navigator.pop(context);
                Get.snackbar(
                  'تم إضافة التقييم بنجاح',
                  'تم إضافة التقييم بنجاح',
                  icon: Icon(Icons.check_circle, color: Colors.green),
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.black,
                  duration: Duration(seconds: 3),
                );
              } else {
                Get.snackbar(
                  'حدث خطأ أثناء إضافة التقييم',
                  'حدث خطأ أثناء إضافة التقييم',
                  icon: Icon(Icons.warning, color: Colors.red),
                  snackPosition: SnackPosition.TOP,
                  colorText: Colors.black,
                  duration: Duration(seconds: 3),
                );
              }
            } catch (e) {
              Get.snackbar(
                'خطأ',
                e.toString(),
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


  Future<void> _fetchReviews() async {
    try {
      final fetchedReviews =
          await RestaurantApi.fetchRestaurantReviews(widget.restaurant.id);
      setState(() {
        reviews = fetchedReviews; // تحديث قائمة التقييمات
        isLoadingReviews = false; // إيقاف حالة التحميل
      });
    } catch (e) {
      setState(() {
        isLoadingReviews = false; // إيقاف حالة التحميل في حالة حدوث خطأ
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('خطأ في تحميل التقييمات: $e')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // قائمة الصور الخاصة بالمطعم
    final List<String> restaurantImages = [
      widget.restaurant.logo,
      ...widget.restaurant.images,
    ];

    return Directionality(
      textDirection: TextDirection.rtl, // عكس اتجاه الشاشة
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primaryColor,
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
                      items: restaurantImages.map((image) {
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
                        children: restaurantImages.asMap().entries.map((entry) {
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
                                widget.restaurant.name,
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
                                      widget.restaurant.address,
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
                      labelColor: AppColors.primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.primaryColor,
                      tabs: const [
                        Tab(text: 'نظرة عامة'),
                        Tab(text: 'القائمة'),
                        Tab(text: 'المراجعات'),
                      ],
                    ),
                    SizedBox(
                      height: 500, // ارتفاع ثابت للمحتوى
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // نظرة عامة
                          _buildOverviewTab(widget.restaurant),
                          // القائمة
                          _buildMenuTab(),
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

  Widget _buildOverviewTab(Restaurant restaurant) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'وصف المطعم',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            restaurant.description.isNotEmpty
                ? restaurant.description
                : 'لا يوجد وصف متاح.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTab() {
    return isLoadingMenu
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : menuItems.isEmpty
            ? Center(
                child: Text(
                  'لا توجد وجبات متاحة حالياً.',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final menuItem = menuItems[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MenuItemDetailScreen(
                                menuItem: menuItem,
                                restaurantId: widget.restaurant.id,
                                restaurantName: widget.restaurant.name,
                              ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            // التحقق من وجود الصورة
                            menuItem.image.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      menuItem.image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.image_not_supported,
                                          size: 100,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  )
                                : Icon(
                                    Icons.image_not_supported,
                                    size: 100,
                                    color: Colors.grey,
                                  ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    menuItem.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    menuItem.description,
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '\$${menuItem.price}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
  }

    Widget _buildReviewsTab() {
    return Column(
      children: [
        // زر إضافة تقييم
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

        // قائمة المراجعات
        if (reviews.isEmpty)
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'لا توجد مراجعات بعد. كن أول من يقيم هذا الفندق!',
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
                                    review.fullName,
                                    style: GoogleFonts.cairo(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    review.createdAt,
                                    style: GoogleFonts.cairo(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RatingBarIndicator(
                              rating: review.rating.toDouble(),
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
    }