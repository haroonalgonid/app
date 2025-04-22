import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:st/theme/color.dart';
import '../../service/HotelService.dart';
import 'hotelDetails_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Hotel {
  final String id;
  final String name;
  final String image;
  final List<String> images; // قائمة بالصور الإضافية
  final double rating;
  final double price;
  final String location;
  final int rooms;
  final List<String> facilities;
  final String description;
  final bool isPromoted;
  final String type; // إضافة حقل النوع

  Hotel({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
    required this.rating,
    required this.price,
    required this.location,
    required this.rooms,
    required this.facilities,
    required this.description,
    this.isPromoted = false,
    required this.type, // إضافة حقل النوع
  });
}

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  _HotelsScreenState createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'الكل';
  bool isLoading = false;
  List<Hotel> hotels = [];

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    setState(() {
      isLoading = true;
    });

    try {
      final hotelsData = await HotelService.getHotels();

      if (hotelsData != null) {
        setState(() {
          hotels = hotelsData.map((hotel) {
            return Hotel(
              id: hotel['id'],
              name: hotel['name'],
              image:
                  '${hotel['logo']}', // إضافة المسار الكامل للصورة الرئيسية
            images: hotel['images'] != null
    ? List<String>.from(hotel['images'].map((img) {
        String formattedPath = img.replaceAll('\\', '/');
        return formattedPath;
      }))
    : [],
              rating: (hotel['averageRating'] as num?)?.toDouble() ?? 0.0,
              price: hotel['price'] ??
                  200, // استخدام قيمة افتراضية إذا لم تكن متاحة
              location: hotel['address'] ?? 'غير محدد',
              description: hotel['description'] ?? "لا يوجد وصف متاح",
              rooms: hotel['rooms'] ??
                  50, // استخدام قيمة افتراضية إذا لم تكن متاحة
              type: hotel['type'] ?? 'غير محدد',
              facilities: List<String>.from(hotel['facilities'] ?? []),
            );
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching hotels: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchBar(),
              _buildCategoryTabs(),
              isLoading ? _buildLoadingIndicator() : _buildHotelsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الفنادق',
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'ابحث عن أفضل الفنادق القريبة',
                    style: GoogleFonts.tajawal(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن فندق...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.tune,
              color: AppColors.red,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

Widget _buildCategoryTabs() {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    height: 45,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildCategoryTab('الكل', 'الكل'),
        _buildCategoryTab('فاخرة', 'luxury'),
        // _buildCategoryTab('أعمال', 'business'),
        _buildCategoryTab('اقتصادية', 'budget'), // إضافة هذا السطر إذا كنت تريد فلتر budget
      ],
    ),
  );
}

  Widget _buildCategoryTab(String title, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.red.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

Widget _buildHotelsList() {
  List<Hotel> filteredHotels = hotels.where((hotel) {
    // تطابق البحث
    bool searchMatch = _searchQuery.isEmpty ||
        hotel.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        hotel.location.toLowerCase().contains(_searchQuery.toLowerCase());
    
    // تطابق الفلتر
    bool categoryMatch;
    if (_selectedFilter == 'الكل') {
      categoryMatch = true;
    } else if (_selectedFilter == 'luxury') {
      categoryMatch = hotel.type.toLowerCase() == 'luxury';
    } else if (_selectedFilter == 'business') {
      categoryMatch = hotel.type.toLowerCase() == 'business';
    } else {
      categoryMatch = false;
    }
    
    return searchMatch && categoryMatch;
  }).toList();

  return Expanded(
    child: filteredHotels.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 60,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  'لا توجد نتائج',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'حاول تغيير مصطلحات البحث',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            itemCount: filteredHotels.length,
            itemBuilder: (context, index) {
              return _buildHotelCard(filteredHotels[index]);
            },
          ),
  );
}

  Widget _buildHotelCard(Hotel hotel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailsScreen(hotel: hotel),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: Image.network(
                  hotel.image, // هذا الآن يجب أن يكون المسار الكامل
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            hotel.name,
                            style: GoogleFonts.cairo(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          // child: const Icon(
                          //   Icons.favorite_border,
                          //   color: AppColors.red,
                          //   size: 18,
                          // ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotel.location,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                hotel.rating.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // إضافة عرض النوع هنا
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.category,
                                color: Colors.blue,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                hotel
                                    .type, // افترض أن لديك حقل type في كلاس Hotel
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // عرض أيقونات المرافق (facilities)
                    Row(
                      children: [
                        ...List.generate(
                          hotel.facilities.length > 3
                              ? 3
                              : hotel.facilities.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                _getAmenityIcon(hotel.facilities[index]),
                                size: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        if (hotel.facilities.length > 3)
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.red.withOpacity(0.1),
                            child: Text(
                              '+${hotel.facilities.length - 3}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
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

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wi-fi':
        return Icons.wifi;
      case 'pool':
        return Icons.pool;
      case 'restaurant':
        return Icons.restaurant;
      case 'spa':
        return Icons.spa;
      case 'parking':
        return Icons.local_parking;
      case 'gym':
        return Icons.fitness_center;
      case 'breakfast':
        return Icons.free_breakfast;
      default:
        return Icons.hotel;
    }
  }
}
