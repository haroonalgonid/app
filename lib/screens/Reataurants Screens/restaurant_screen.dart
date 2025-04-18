import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:st/theme/color.dart';
import '../../service/restaurants_service.dart';
import 'restaurantDetail_screen.dart';

class Restaurant {
  final String id;
  final String name;
  final String type;
  final String address;
  final String cuisines;
  final String logo;
  final double averageRating;
  final String description;
  final int totalReviews;
  final List<String> images;

  Restaurant({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.cuisines,
    required this.logo,
    required this.averageRating,
    required this.description,
    required this.totalReviews,
    required this.images,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final restaurantData = json['restaurant'] ?? json;

    // معالجة مسار الشعار
    String logo = restaurantData['logo'] ?? '';
    if (logo.isNotEmpty) {
      if (!logo.startsWith('http')) {
        // إزالة أي شرطة مائلة زائدة
        logo = logo.startsWith('/') ? logo.substring(1) : logo;
        logo = '$logo';
      }
      // استبدال المسارات غير الصحيحة إذا لزم الأمر
      logo = logo.replaceAll('//', '/').replaceAll(':/', '://');
    }

    // معالجة مسارات الصور
    List<String> images = [];
    if (restaurantData['images'] != null) {
      images = List<String>.from(restaurantData['images'].map((image) {
        if (image.isNotEmpty && !image.startsWith('http')) {
          image = image.startsWith('/') ? image.substring(1) : image;
          image = '$image';
        }
        return image.replaceAll('//', '/').replaceAll(':/', '://');
      }));
    }

    return Restaurant(
      id: restaurantData['_id'] ?? '',
      name: restaurantData['name'] ?? 'Unknown',
      type: restaurantData['type'] ?? 'Unknown',
      address: restaurantData['address'] ?? 'Unknown',
      cuisines: restaurantData['cuisines'] ?? '',
      logo: logo,
      averageRating: (restaurantData['averageRating'] ?? json['averageRating'])
              ?.toDouble() ??
          0.0,
      description: restaurantData['description'] ?? '',
      totalReviews: restaurantData['totalReviews'] ?? json['totalReviews'] ?? 0,
      images: images,
    );
  }
}

class RestaurantsScreen extends StatefulWidget {
  const RestaurantsScreen({super.key});

  @override
  _RestaurantsScreenState createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'الكل';

  // قائمة الفلاتر الجديدة
  final List<Map<String, String>> filters = [
    {'title': 'الكل', 'value': 'الكل'},
    {'title': 'وجبات سريعة', 'value': 'fast_food'},
    {'title': 'مطاعم عادية', 'value': 'casual_dining'},
    {'title': 'مطاعم فاخرة', 'value': 'fine_dining'},
    // {'title': 'مأكولات بحرية', 'value': 'seafood'},
    // {'title': 'مشاوي', 'value': 'grill'},
    // {'title': 'عربية', 'value': 'arabic'},
  ];

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
              Expanded(
                child: FutureBuilder<List<Restaurant>>(
                  future: RestaurantApi.fetchRestaurants(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('خطأ: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('لا توجد مطاعم متاحة'));
                    } else {
                      final restaurants = snapshot.data!;
                      return _buildRestaurantsList(restaurants);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
                    'المطاعم',
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'ابحث عن أفضل المطاعم القريبة',
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
          hintText: 'ابحث عن مطعم...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
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
        children: filters.map((filter) {
          return _buildCategoryTab(filter['title']!, filter['value']!);
        }).toList(),
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

  Widget _buildRestaurantsList(List<Restaurant> restaurants) {
    List<Restaurant> filteredRestaurants = restaurants.where((restaurant) {
      bool categoryMatch = _selectedFilter == 'الكل' ||
          restaurant.type.toLowerCase().contains(_selectedFilter.toLowerCase());
      bool searchMatch = _searchQuery.isEmpty ||
          restaurant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          restaurant.address.toLowerCase().contains(_searchQuery.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();

    return filteredRestaurants.isEmpty
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
            itemCount: filteredRestaurants.length,
            itemBuilder: (context, index) {
              return _buildRestaurantCard(filteredRestaurants[index]);
            },
          );
  }

  Widget _buildRestaurantCard(Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RestaurantDetailScreen(restaurant: restaurant),
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
  child: CachedNetworkImage(
    imageUrl: restaurant.logo,
    width: 120,
    height: 120,
    fit: BoxFit.cover,
    placeholder: (context, url) => Container(
      color: Colors.grey[300],
      child: const Center(child: CircularProgressIndicator()),
    ),
    errorWidget: (context, url, error) => Container(
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    ),
  ),
),
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
                            restaurant.name,
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
                            restaurant.address,
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
                                restaurant.averageRating.toString(),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            restaurant.type,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
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
}
