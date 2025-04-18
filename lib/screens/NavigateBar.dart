import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:st/screens/Settings%20Screens/profile_screen.dart';
import '../Widget/side_menu.dart';
import 'Settings Screens/reservation_screen.dart';
import 'home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _selectedIndex = 1; // تم تغيير القيمة إلى 1 لفتح الشاشة الرئيسية مباشرة

  // قائمة الشاشات
  final List<Widget> _screens = [
    const CombinedBookingsScreen(), // شاشة الحجوزات
    ServiceScreen(), // الشاشة الرئيسية
    ProfileScreen(), // شاشة البروفيل
  ];

  // قائمة عناصر القائمة السفلية
  final List<Map<String, dynamic>> _navItems = [
    {
      'icon': Icons.home_repair_service_sharp,
      'label': 'الحجوزات',
      'activeColor': Colors.green,
    },
    {
      'icon': Icons.home,
      'label': 'الرئيسية',
      'activeColor': Colors.green,
    },
    {
      'icon': Icons.person,
      'label': 'الملف التعريفي',
      'activeColor': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex); // يتم تعيين الصفحة الأولية إلى 1
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    HapticFeedback.lightImpact(); // إضافة اهتزاز عند النقر
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الشاشة الرئيسية باستخدام PageView
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _screens,
          ),

          // أيقونة القائمة (ثلاث نقاط)
        Positioned(
  top: 40, // المسافة من الأعلى
  right: 20, // المسافة من اليمين
  child: Row(
    children: [
      // أيقونة الإشعارات
      // IconButton(
      //   icon: const Icon(Icons.notifications, color: Colors.black),
      //   onPressed: () {
          // الانتقال إلى صفحة الإشعارات
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => Firebasemessaging()),
          // );
      //   },
      // ),
      const SizedBox(width: 10), // مسافة بين الأيقونتين
      // أيقونة القائمة الجانبية
      Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // فتح القائمة الجانبية
            },
          );
        },
      ),
    ],
  ),
),
        ],
      ),
      
      drawer: const SideMenu(), // استخدام القائمة الجانبية المنفصلة
      bottomNavigationBar: Container(
        height: 85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 25,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isSelected = _selectedIndex == index;

              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 22 : 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Icon(
                          item['icon'],
                          color: isSelected ? Colors.green : Colors.grey.shade600,
                          size: isSelected ? 30 : 26,
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: SizedBox(width: isSelected ? 12 : 0),
                      ),
                      if (isSelected)
                        AnimatedOpacity(
                          opacity: isSelected ? 1 : 0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: Text(
                            item['label'],
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // التخلص من PageController
    super.dispose();
  }
}