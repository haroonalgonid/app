import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../service/HotelService.dart';
import '../../theme/color.dart';
import 'hotel_screen.dart';
import 'room_details_screen.dart';

class Room {
  final String id;
  final String hotelName;
  final String hotelAddress;
  final String name;
  final String image;
  final num price;
  final int bedCount;
  final int suiteRoomCount;
  final String size;
  final String description;
  final List<String> amenities;
  final List<String> images;
  final bool availability;
  final DateTime createdAt;
  final DateTime updatedAt;

  Room({
    required this.id,
    required this.hotelName,
    required this.hotelAddress,
    required this.name,
    required this.image,
    required this.price,
    required this.bedCount,
    required this.suiteRoomCount,
    required this.size,
    required this.description,
    required this.amenities,
    required this.images,
    required this.availability,
    required this.createdAt,
    required this.updatedAt,
  });
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

class HotelDetailsScreen extends StatefulWidget {
  final Hotel hotel;

  const HotelDetailsScreen({super.key, required this.hotel});

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsScreenState();
}

class _HotelDetailsScreenState extends State<HotelDetailsScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // إضافة هذه الميزة لتجنب إعادة التحميل
  @override
  bool get wantKeepAlive => true;

  int _currentImageIndex = 0;
  late TabController _tabController;
  bool isFavorite = false;
  List<Review> reviews = [];
  List<Room>? rooms; // لتخزين الغرف بعد جلبها

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // جلب الغرف والمراجعات عند بدء الشاشة
    _fetchRooms();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final reviewsData = await HotelService.getHotelReviews(widget.hotel.id);
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
        print("No reviews found for this hotel.");
      }
    } catch (e) {
      print("Error fetching reviews: $e");
      setState(() {
        reviews = []; // ضبط المراجعات كقائمة فارغة في حالة حدوث خطأ
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

            final success = await HotelService.addHotelReview(
              widget.hotel.id,
              rating!.toInt(),
              comment,
            );

            if (success) {
              _fetchReviews(); // تحديث قائمة المراجعات بعد الإضافة
              Navigator.pop(context);
              Get.snackbar(
                'تم إضافة التقييم بنجاح',
                'تم إضافة تقييمك للفندق بنجاح.',
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


  Future<void> _fetchRooms() async {
    try {
      final fetchedRooms = await HotelService.getHotelRooms(widget.hotel.id);
      print("Fetched Rooms: $fetchedRooms");
      if (fetchedRooms != null) {
        setState(() {
          rooms = fetchedRooms
              .map((roomData) => Room(
                    id: roomData['id'],
                    hotelName: widget.hotel.name,
                    hotelAddress: widget.hotel.location,
                    name: roomData['type'],
                    image: roomData['images'].isNotEmpty
                        ? roomData['images'][0]
                        : '',
                    price: roomData['pricePerNight'],
                    bedCount: roomData['bedCount'] ?? 1,
                    suiteRoomCount: roomData['suiteRoomCount'] ?? 0,
                    size: roomData['size'].toString(),
                    description: roomData['view'],
                    amenities: List<String>.from(roomData['amenities'] ?? []),
                    images: List<String>.from(roomData['images'] ?? []),
                    availability: roomData['isAvailable'],
                    createdAt: DateTime.parse(
                        roomData['createdAt'] ?? DateTime.now().toString()),
                    updatedAt: DateTime.parse(
                        roomData['updatedAt'] ?? DateTime.now().toString()),
                  ))
              .toList();
        });
      } else {
        print("No rooms found for this hotel.");
      }
    } catch (e) {
      print("Error fetching rooms: $e");
      setState(() {
        rooms = []; // ضبط الغرف كقائمة فارغة في حالة حدوث خطأ
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addReview(Review review) {
    setState(() {
      reviews.add(review);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ضروري لـ AutomaticKeepAliveClientMixin
    final List<String> hotelImages = widget.hotel.images.isNotEmpty
        ? widget.hotel.images
        : [
            widget.hotel.image, // استخدام الصورة الرئيسية كبديل
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
                            _currentImageIndex =
                                index; // تحديث الفهرس الحالي للصورة المعروضة
                          });
                        },
                      ),
                      items: hotelImages.map((image) {
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
                        children: hotelImages.asMap().entries.map((entry) {
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
                                widget.hotel.name,
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
                                      widget.hotel.location,
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
                        Tab(text: 'الغرف وا الاجنحه'),
                        Tab(text: 'المراجعات'),
                      ],
                    ),
                    SizedBox(
                      height: 500,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // نظرة عامة
                          _buildOverviewTab(widget.hotel),
                          // الغرف
                          rooms == null
                              ? Center(child: CircularProgressIndicator())
                              : rooms!.isEmpty
                                  ? Center(
                                      child: Text(
                                        'لا توجد غرف متاحة.',
                                        style: GoogleFonts.cairo(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    )
                                  : _buildRoomsTab(rooms!),
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

  Widget _buildOverviewTab(Hotel hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'وصف الفندق',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hotel.description.isNotEmpty
                ? hotel.description
                : "لا يوجد وصف متاح",
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'المرافق',
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: hotel.facilities.map((amenity) {
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
                      _getAmenityIcon(amenity),
                      size: 20,
                      color: AppColors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amenity,
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
        ],
      ),
    );
  }

  Widget _buildRoomsTab(List<Room> rooms) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoomDetailsScreen(room: room),
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    room.image,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                            room.name,
                            style: GoogleFonts.cairo(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\$${room.price}/ليلة',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.orange,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        room.description,
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: room.amenities.map((amenity) {
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
