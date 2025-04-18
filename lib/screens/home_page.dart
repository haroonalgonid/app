import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحباً بك 👋',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'اكتشف خدماتنا المميزة',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF9698A9),
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildServiceCard(services[index], index),
                  childCount: services.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, int index) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            1.0,
            curve: Curves.easeOut,
          ),
        )),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: service['color'].withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.pushNamed(context, service['route']),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: service['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        service['icon'],
                        color: service['color'],
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['label'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service['description'] ?? 'اضغط للمزيد من التفاصيل',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9698A9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF9698A9),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> services = [
  {
    'icon': Icons.airplanemode_active,
    'label': 'تذاكر الطيران',
    'color': const Color(0xFF4C6EF8),
    'description': 'احجز رحلتك القادمة بأفضل الأسعار',
    'route': '/flight_tickets',
  },
  {
    'icon': Icons.local_hospital,
    'label': 'المستشفيات',
    'color': const Color(0xFFFF647C),
    'description': 'اعثر على أقرب مستشفى إليك',
    'route': '/hospitals',
  },
  {
    'icon': Icons.hotel,
    'label': 'الفنادق',
    'color': const Color(0xFFFFAA5C),
    'description': 'احجز إقامتك بأفضل العروض',
    'route': '/hotels',
  },
  {
    'icon': Icons.restaurant,
    'label': 'المطاعم',
    'color': const Color(0xFF2AC769),
    'description': 'استكشف أشهى المأكولات',
    'route': '/restaurants',
  },
  {
    'icon': Icons.directions_bus,
    'label': 'المواصلات',
    'color': const Color(0xFF9C6EFF),
    'description': 'تنقل بسهولة وأمان',
    'route': '/transportation',
  },
];