import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:st/theme/color.dart';
import '../../service/CarRentalService.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'CarCompanyDetailsScreen.dart';

class CarCompany {
  final String id;
  final String name;
  final String image;
  final List<String> images;
  final double rating;
  final double price;
  final String location;
  final int availableCars;
  final List<String> services;
  final String description;
  final bool isPromoted;
  final String type;

  CarCompany({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
    required this.rating,
    required this.price,
    required this.location,
    required this.availableCars,
    required this.services,
    required this.description,
    this.isPromoted = false,
    required this.type,
  });
}

class CarCompaniesScreen extends StatefulWidget {
  const CarCompaniesScreen({super.key});

  @override
  _CarCompaniesScreenState createState() => _CarCompaniesScreenState();
}

class _CarCompaniesScreenState extends State<CarCompaniesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'الكل';
  bool isLoading = false;
  List<CarCompany> companies = [];

  @override
  void initState() {
    super.initState();
    _fetchCarCompanies();
  }

  Future<void> _fetchCarCompanies() async {
    setState(() {
      isLoading = true;
    });

    try {
      final companiesData = await CarRentalService.getCarRentals();

      if (companiesData != null) {
        setState(() {
          companies = companiesData.map((company) {
            return CarCompany(
              id: company['id'],
              name: company['name'],
              image: '${company['logo']}',
              images: company['images'] != null
                  ? List<String>.from(company['images'].map((img) {
                      String formattedPath = img.replaceAll('\\', '/');
                      return '$formattedPath';
                    }))
                  : [],
              rating: (company['averageRating'] as num?)?.toDouble() ?? 0.0,
              price: company['price'] ?? 200,
              location: company['address'] ?? 'غير محدد',
              description: company['description'] ?? "لا يوجد وصف متاح",
              availableCars: company['availableCars'] ?? 10,
              type: company['type'] ?? 'غير محدد',
              services: List<String>.from(company['services'] ?? []),
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
      print('Error fetching car companies: $e');
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
              isLoading ? _buildLoadingIndicator() : _buildCompaniesList(),
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
                    'شركات السيارات',
                    style: GoogleFonts.tajawal(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'ابحث عن أفضل شركات تأجير السيارات',
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
          hintText: 'ابحث عن شركة سيارات...',
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
        children: [
          _buildCategoryTab('الكل', 'الكل'),
          _buildCategoryTab('فاخرة', 'luxury'),
          _buildCategoryTab('اقتصادية', 'budget'),
          _buildCategoryTab('تجاري', 'commercial'),
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

  Widget _buildCompaniesList() {
    List<CarCompany> filteredCompanies = companies.where((company) {
      bool searchMatch = _searchQuery.isEmpty ||
          company.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          company.location.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool categoryMatch;
      if (_selectedFilter == 'الكل') {
        categoryMatch = true;
      } else {
        categoryMatch = company.type.toLowerCase() == _selectedFilter.toLowerCase();
      }
      
      return searchMatch && categoryMatch;
    }).toList();

    return Expanded(
      child: filteredCompanies.isEmpty
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
              itemCount: filteredCompanies.length,
              itemBuilder: (context, index) {
                return _buildCompanyCard(filteredCompanies[index]);
              },
            ),
    );
  }

  Widget _buildCompanyCard(CarCompany company) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CarCompanyDetailsScreen(company: company),
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
                company.image,
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
                            company.name,
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
                            company.location,
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
                                company.rating.toString(),
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
                          child: Row(
                            children: [
                              const Icon(
                                Icons.directions_car,
                                color: Colors.blue,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                company.type,
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
                    Row(
                      children: [
                        ...List.generate(
                          company.services.length > 3 ? 3 : company.services.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey[200],
                              child: Icon(
                                _getServiceIcon(company.services[index]),
                                size: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                        ),
                        if (company.services.length > 3)
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.red.withOpacity(0.1),
                            child: Text(
                              '+${company.services.length - 3}',
                              style: TextStyle(
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