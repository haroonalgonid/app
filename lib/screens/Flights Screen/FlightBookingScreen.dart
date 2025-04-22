import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../service/flight_service.dart';
import 'FlightSearchScreen.dart';
import 'flightDetail_screen.dart';
import '../../theme/color.dart';

class FlightBookingScreen extends StatelessWidget {
  const FlightBookingScreen({super.key});

  // تعريف اللون الأخضر الأساسي
  static const mainGreen =
      Color(0xFF2E7D32); // يمكنك تغيير درجة اللون الأخضر حسب رغبتك

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFFF5F6FA),
              automaticallyImplyLeading: true,
              flexibleSpace: FlexibleSpaceBar(
                // title: const Text(
                //   'اكتشف العالم',
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 26,
                //   ),
                // ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            mainGreen,
                            mainGreen.withOpacity(0.7),
                            Colors.teal[400]!,
                          ],
                        ),
                      ),
                    ),
                    // إضافة نمط زخرفي
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: 70,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'رحلات مميزة بأسعار تنافسية',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    _buildSearchBox(context),
                    const SizedBox(height: 25),
                    // _buildQuickActions(),
                    const SizedBox(height: 25),
                    _buildPopularFlights(context),
                    const SizedBox(height: 25),
                    _buildSpecialDeals(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 // تعديل دالة _buildSearchBox
Widget _buildSearchBox(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FlightSearchScreen()),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: mainGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.flight_takeoff,
                  color: mainGreen,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إلى أين تود السفر؟',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'اضغط للبحث عن رحلتك',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: mainGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  // Widget _buildQuickActions() {
  //   final actions = [
  //     {'icon': Icons.flight, 'title': 'رحلات'},
  //     {'icon': Icons.hotel, 'title': 'فنادق'},
  //     {'icon': Icons.directions_car, 'title': 'سيارات'},
  //     {'icon': Icons.card_giftcard, 'title': 'عروض'},
  //   ];

  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
  //     children: actions.map((action) {
  //       return Column(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(15),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(20),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.2),
  //                   spreadRadius: 2,
  //                   blurRadius: 8,
  //                   offset: const Offset(0, 3),
  //                 ),
  //               ],
  //               gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 colors: [
  //                   Colors.white,
  //                   Colors.white,
  //                 ],
  //               ),
  //             ),
  //             child: Icon(
  //               action['icon'] as IconData,
  //               color: mainGreen,
  //               size: 30,
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             action['title']! as String,
  //             style: TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w600,
  //               color: Colors.grey[800],
  //             ),
  //           ),
  //         ],
  //       );
  //     }).toList(),
  //   );
  // }

 // تعديل دالة _buildPopularFlights
Widget _buildPopularFlights(BuildContext context) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: FlightService.fetchFlights(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
          ),
        );
      } else if (snapshot.hasError) {
        return const Center(child: Text("فشل في تحميل البيانات"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("لا توجد رحلات متاحة"));
      }

      final flights = snapshot.data!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الرحلات المتوفرة',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: mainGreen,
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     // يمكن إضافة التنقل إلى صفحة كل الرحلات هنا
              //   },
              //   child: Text(
              //     'عرض الكل',
              //     style: TextStyle(
              //       color: mainGreen,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: flights.length,
              itemBuilder: (context, index) {
                final flight = flights[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FlightDetailScreen(flightId: flight["id"]),
                      ),
                    );
                  },
                  child: Container(
                    width: 220,
                    margin: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: mainGreen.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.flight,
                              color: mainGreen,
                              size: 50,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'إلى ${flight["arrivalAirport"]}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: mainGreen,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Row(
                              //   children: [
                              //     Icon(
                              //       Icons.calendar_today,
                              //       size: 16,
                              //       color: Colors.grey[600],
                              //     ),
                              //     const SizedBox(width: 5),
                              //     Text(
                              //       flight["departureTime"] ?? "غير محدد",
                              //       style: TextStyle(
                              //         color: Colors.grey[600],
                              //         fontSize: 14,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${flight["priceEconomy"]}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: mainGreen,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: mainGreen,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Text(
                                      'احجز الآن',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
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
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

  Widget _buildSpecialDeals(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: FlightService.fetchDiscountedFlights(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(mainGreen),
          ));
        } else if (snapshot.hasError) {
          return const Center(child: Text("فشل في تحميل العروض الخاصة"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد عروض خاصة متاحة"));
        }

        final discountedFlights = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'عروض خاصة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: mainGreen,
              ),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: discountedFlights.length,
              itemBuilder: (context, index) {
                final flight = discountedFlights[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FlightDetailScreen(flightId: flight["id"]),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: mainGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.flight,
                              color: mainGreen,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mainGreen.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'خصم ${flight["discount"]}%',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: mainGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'إلى ${flight["arrivalAirport"]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'السعر: \$${flight["priceEconomy"]}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: mainGreen,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Text(
                              'احجز الآن',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
