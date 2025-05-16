import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../service/TokenManager.dart';

class Booking {
  final String flightNumber;
  final String departureAirport;
  final String arrivalAirport;
  final String departureTime;
  final String arrivalTime;
  final String seatNumber;
  final String flightClass;
  final double ticketPrice;
  final String passportNumber;
  final String status;

  Booking({
    required this.flightNumber,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTime,
    required this.arrivalTime,
    required this.seatNumber,
    required this.flightClass,
    required this.ticketPrice,
    required this.passportNumber,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // التحقق من أن json['flight'] موجود وليس null
    final flight = json['flight'] ?? {};

    return Booking(
      flightNumber: flight['flightNumber']?.toString() ?? '---',
      departureAirport: flight['departureAirport']?.toString() ?? '---',
      arrivalAirport: flight['arrivalAirport']?.toString() ?? '---',
      departureTime: flight['departureTime']?.toString() ?? '---',
      arrivalTime: flight['arrivalTime']?.toString() ?? '---',
      seatNumber: json['seatNumber']?.toString() ?? '---',
      flightClass: json['class']?.toString() ?? '---',
      ticketPrice: (json['ticketPrice'] != null)
          ? (json['ticketPrice'] as num).toDouble()
          : 0.0,
      passportNumber: json['passportNumber']?.toString() ?? '---',
      status: json['status']?.toString() ?? '---',
    );
  }
}

class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String hospitalName;
  final String hospitalAddress;
  final String dateTime;
  final String status;
  final String paymentStatus;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.dateTime,
    required this.status,
    required this.paymentStatus,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] ?? '',
      doctorName: json['doctor']['name'] ?? '',
      specialty: json['doctor']['specialty'] ?? '',
      hospitalName: json['doctor']['hospital']['name'] ?? '',
      hospitalAddress: json['doctor']['hospital']['address'] ?? '',
      dateTime: json['dateTime'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
    );
  }
}

class HotelBooking {
  final String id;
  final String userId;
  final Room room;
  final String checkInDate;
  final String checkOutDate;
  final String status;
  final String paymentStatus;
  final String createdAt;
  final double totalPrice;

  HotelBooking({
    required this.id,
    required this.userId,
    required this.room,
    required this.checkInDate,
    required this.checkOutDate,
    required this.status,
    required this.paymentStatus,
    required this.createdAt,
    required this.totalPrice,
  });

  factory HotelBooking.fromJson(Map<String, dynamic> json) {
    return HotelBooking(
      id: json['_id'] ?? '',
      userId: json['user'] ?? '',
      room: Room.fromJson(json['room']),
      checkInDate: json['checkInDate'] ?? '',
      checkOutDate: json['checkOutDate'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      createdAt: json['createdAt'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }
}

class Room {
  final String id;
  final String type;
  final double pricePerNight;

  Room({
    required this.id,
    required this.type,
    required this.pricePerNight,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      pricePerNight: (json['pricePerNight'] ?? 0).toDouble(),
    );
  }
}

class RestaurantOrder {
  final String id;
  final String restaurantName;
  final String restaurantAddress;
  final List<OrderItem> items;
  final double totalPrice;
  final String status;
  final String paymentStatus;
  final String orderDate;

  RestaurantOrder({
    required this.id,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.paymentStatus,
    required this.orderDate,
  });

  factory RestaurantOrder.fromJson(Map<String, dynamic> json) {
    List<OrderItem> menuItems = [];
    if (json['menuItems'] != null) {
      for (var item in json['menuItems']) {
        menuItems.add(OrderItem.fromJson(item));
      }
    }

    return RestaurantOrder(
      id: json['_id'] ?? '',
      restaurantName: json['restaurant']['name'] ?? '',
      restaurantAddress: json['restaurant']['address'] ?? '',
      items: menuItems,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      orderDate: json['orderDate'] ?? '',
    );
  }
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      name: json['menuItem']['name'] ?? '',
      price: (json['menuItem']['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
    );
  }
}

class CarBooking {
  final String id;
  final String carMake;
  final String carModel;
  final double pricePerDay;
  final String pickupDate;
  final String returnDate;
  final String pickupLocation;
  final String returnLocation;
  final String status;
  final String paymentStatus;
  final double totalPrice;
  final String driverLicenseNumber;

  CarBooking({
    required this.id,
    required this.carMake,
    required this.carModel,
    required this.pricePerDay,
    required this.pickupDate,
    required this.returnDate,
    required this.pickupLocation,
    required this.returnLocation,
    required this.status,
    required this.paymentStatus,
    required this.totalPrice,
    required this.driverLicenseNumber,
  });

  factory CarBooking.fromJson(Map<String, dynamic> json) {
    return CarBooking(
      id: json['_id'] ?? '',
      carMake: json['car']['make'] ?? '',
      carModel: json['car']['model'] ?? '',
      pricePerDay: (json['car']['pricePerDay'] ?? 0).toDouble(),
      pickupDate: json['pickupDate'] ?? '',
      returnDate: json['returnDate'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      returnLocation: json['returnLocation'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      driverLicenseNumber: json['driverLicenseNumber'] ?? '',
    );
  }
}

class BookingService {
  static const String baseUrl = "https://backend-fpnx.onrender.com";

  static Future<List<Booking>> fetchUserBookings() async {
    String? accessToken = await TokenManager.getAccessToken();

    if (accessToken == null) {
      return Future.error('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/bookings/my-bookings'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      Map<String, dynamic> errorData = jsonDecode(response.body);
      return Future.error(errorData['message'] ?? 'Unknown error');
    }
  }

  static Future<List<Appointment>> fetchUserAppointments() async {
    String? accessToken = await TokenManager.getAccessToken();

    if (accessToken == null) {
      return Future.error('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/hospitals/appointments'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> appointments = data['appointments'];
      return appointments.map((json) => Appointment.fromJson(json)).toList();
    } else {
      Map<String, dynamic> errorData = jsonDecode(response.body);
      return Future.error(errorData['message'] ?? 'Unknown error');
    }
  }

  static Future<List<HotelBooking>> fetchUserHotelBookings() async {
    String? accessToken = await TokenManager.getAccessToken();

    if (accessToken == null) {
      return Future.error('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/hotels/bookings'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> bookings = data['bookings'];
      return bookings.map((json) => HotelBooking.fromJson(json)).toList();
    } else {
      Map<String, dynamic> errorData = jsonDecode(response.body);
      return Future.error(errorData['message'] ?? 'Unknown error');
    }
  }

  static Future<List<RestaurantOrder>> fetchRestaurantOrders() async {
    String? accessToken = await TokenManager.getAccessToken();

    if (accessToken == null) {
      return Future.error('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/restaurants/orders'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> orders = data['orders'];
      return orders.map((json) => RestaurantOrder.fromJson(json)).toList();
    } else {
      Map<String, dynamic> errorData = jsonDecode(response.body);
      return Future.error(errorData['message'] ?? 'Unknown error');
    }
  }

  static Future<List<CarBooking>> fetchCarBookings() async {
    String? accessToken = await TokenManager.getAccessToken();

    if (accessToken == null) {
      return Future.error('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/carrental/bookings'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> bookings = data['bookings'];
      return bookings.map((json) => CarBooking.fromJson(json)).toList();
    } else {
      Map<String, dynamic> errorData = jsonDecode(response.body);
      return Future.error(errorData['message'] ?? 'Unknown error');
    }
  }
}

class CombinedBookingsScreen extends StatefulWidget {
  const CombinedBookingsScreen({super.key});

  @override
  _CombinedBookingsScreenState createState() => _CombinedBookingsScreenState();
}

class _CombinedBookingsScreenState extends State<CombinedBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Booking>> futureBookings;
  late Future<List<Appointment>> futureAppointments;
  late Future<List<HotelBooking>> futureHotelBookings;
  late Future<List<RestaurantOrder>> futureRestaurantOrders;
  late Future<List<CarBooking>> futureCarBookings;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    futureBookings = BookingService.fetchUserBookings();
    futureAppointments = BookingService.fetchUserAppointments();
    futureHotelBookings = BookingService.fetchUserHotelBookings();
    futureRestaurantOrders = BookingService.fetchRestaurantOrders();
    futureCarBookings = BookingService.fetchCarBookings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String getStatusArabic(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'مؤكد';
      case 'pending':
        return 'قيد الانتظار';
      case 'cancelled':
        return 'ملغي';
      case 'unpaid':
        return 'غير مدفوع';
      case 'paid':
        return 'مدفوع';
      case 'delivered':
        return 'تم التوصيل';
      case 'processing':
        return 'قيد التجهيز';
      default:
        return status;
    }
  }

Color getStatusColor(String status) {
  if (status.isEmpty) {
    return Colors.grey; // لون افتراضي إذا كانت الحالة غير موجودة
  }
  
  switch (status.toLowerCase()) {
    case 'confirmed':
      return Colors.green;
    case 'pending':
      return Colors.orange;
    case 'cancelled':
      return Colors.red;
    case 'paid':
      return Colors.green;
    case 'unpaid':
      return Colors.red;
    case 'delivered':
      return Colors.green;
    case 'processing':
      return Colors.blue;
    default:
      return Colors.grey;
  }

  }

  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

String formatDateTime(String? dateString) {
  if (dateString == null || dateString.isEmpty || dateString == '---') {
    return 'غير متوفر';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  } catch (e) {
    return 'تنسيق غير صالح';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        automaticallyImplyLeading: false, // هذا يمنع ظهور زر الرجوع
        title: Text(
          'حجوزاتي',
          style: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.orange,
          labelColor: Colors.orange,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'الطيران'),
            Tab(text: 'الفنادق'),
            Tab(text: 'المواعيد'),
            Tab(text: 'المطاعم'),
            Tab(text: 'السيارات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // تبويب حجوزات الطيران
          FutureBuilder<List<Booking>>(
            future: futureBookings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(
                    Icons.flight, 'لا توجد حجوزات طيران حالياً');
              } else {
                return _buildBookingsList(snapshot.data!);
              }
            },
          ),

          // تبويب حجوزات الفنادق
          FutureBuilder<List<HotelBooking>>(
            future: futureHotelBookings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(
                    Icons.hotel, 'لا توجد حجوزات فنادق حالياً');
              } else {
                return _buildHotelBookingsList(snapshot.data!);
              }
            },
          ),

          // تبويب المواعيد الطبية
          FutureBuilder<List<Appointment>>(
            future: futureAppointments,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(
                    Icons.medical_services, 'لا توجد مواعيد طبية حالياً');
              } else {
                return _buildAppointmentsList(snapshot.data!);
              }
            },
          ),

          // تبويب طلبات المطاعم
          FutureBuilder<List<RestaurantOrder>>(
            future: futureRestaurantOrders,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(
                    Icons.restaurant, 'لا توجد طلبات مطاعم حالياً');
              } else {
                return _buildRestaurantOrdersList(snapshot.data!);
              }
            },
          ),

          // تبويب حجوزات السيارات
          FutureBuilder<List<CarBooking>>(
            future: futureCarBookings,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(
                    Icons.directions_car, 'لا توجد حجوزات سيارات حالياً');
              } else {
                return _buildCarBookingsList(snapshot.data!);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Text(
        '$error',
        style: GoogleFonts.cairo(color: Colors.red),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.cairo(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList(List<Booking> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildBookingCard(bookings[index]);
      },
    );
  }

  Widget _buildHotelBookingsList(List<HotelBooking> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildHotelBookingCard(bookings[index]);
      },
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _buildAppointmentCard(appointments[index]);
      },
    );
  }

  Widget _buildRestaurantOrdersList(List<RestaurantOrder> orders) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildRestaurantOrderCard(orders[index]);
      },
    );
  }

  Widget _buildCarBookingsList(List<CarBooking> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return _buildCarBookingCard(bookings[index]);
      },
    );
  }
Widget _buildBookingCard(Booking booking) {
  return Card(
    elevation: 4,
    margin: const EdgeInsets.only(bottom: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        // Header Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.flight, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                'رحلة رقم: ${booking.flightNumber}',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
        ),
        
        // Content Section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Airports Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'من',
                          style: GoogleFonts.cairo(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          booking.departureAirport,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: booking.departureAirport == '---' ? Colors.grey : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward, color: Colors.orange),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'إلى',
                          style: GoogleFonts.cairo(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          booking.arrivalAirport,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: booking.arrivalAirport == '---' ? Colors.grey : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 24),
              
              // Flight Times
              _buildInfoRow(
                'وقت الإقلاع',
                booking.departureTime,
                Icons.access_time,
              ),
              
              _buildInfoRow(
                'وقت الوصول',
                booking.arrivalTime,
                Icons.access_time,
              ),
              
              // Seat Information
              _buildInfoRow(
                'رقم المقعد',
                booking.seatNumber,
                Icons.event_seat,
              ),
              
              // _buildInfoRow(
              //   'فئة المقعد',
              //   booking.flightClass,
              //   Icons.airline_seat_recline_extra,
              // ),
              
              // Price
              _buildInfoRow(
                'السعر',
                '${booking.ticketPrice.toStringAsFixed(2)} دولار',
                Icons.attach_money,
              ),
              
              // Passport Number
              _buildInfoRow(
                'رقم الجواز',
                booking.passportNumber,
                Icons.credit_card,
              ),
              
              const SizedBox(height: 16),
              
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(booking.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getStatusArabic(booking.status),
                  style: GoogleFonts.cairo(
                    color: getStatusColor(booking.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// تعديل الدالة لتحسين عرض القيم الفارغة
Widget _buildInfoRow(String label, String value, IconData icon) {
  final displayValue = (value == '---') ? 'غير متوفر' : value;
  
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.cairo(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            displayValue,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: (value == '---') ? Colors.grey : null,
            ),
          ),
        ),
      ],
    ),
  );
}

    
  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.medical_services,
                    color: Colors.blue, size: 24),
                const SizedBox(width: 8),
                Text(
                  'موعد طبي',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  'الطبيب',
                  appointment.doctorName,
                  Icons.person,
                ),
                _buildInfoRow(
                  'المستشفى',
                  appointment.hospitalName,
                  Icons.local_hospital,
                ),
                _buildInfoRow(
                  'التخصص',
                  appointment.specialty,
                  Icons.medical_services,
                ),
                _buildInfoRow(
                  'تاريخ ووقت الموعد',
                  formatDateTime(appointment.dateTime),
                  Icons.access_time,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            getStatusColor(appointment.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusArabic(appointment.status),
                        style: GoogleFonts.cairo(
                          color: getStatusColor(appointment.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(appointment.paymentStatus)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusArabic(appointment.paymentStatus),
                        style: GoogleFonts.cairo(
                          color: getStatusColor(appointment.paymentStatus),
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildHotelBookingCard(HotelBooking booking) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.hotel, color: Colors.purple, size: 24),
                const SizedBox(width: 8),
                Text(
                  'حجز فندق',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[700],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  'نوع الغرفة',
                  booking.room.type,
                  Icons.king_bed,
                ),
                _buildInfoRow(
                  'سعر الليلة',
                  '${booking.room.pricePerNight} دولار',
                  Icons.attach_money,
                ),
                _buildInfoRow(
                  'تاريخ الوصول',
                  formatDate(booking.checkInDate),
                  Icons.calendar_today,
                ),
                _buildInfoRow(
                  'تاريخ المغادرة',
                  formatDate(booking.checkOutDate),
                  Icons.calendar_today,
                ),
                _buildInfoRow(
                  'المبلغ الإجمالي',
                  '${booking.totalPrice} دولار',
                  Icons.money,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(booking.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusArabic(booking.status),
                        style: GoogleFonts.cairo(
                          color: getStatusColor(booking.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(booking.paymentStatus)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusArabic(booking.paymentStatus),
                        style: GoogleFonts.cairo(
                          color: getStatusColor(booking.paymentStatus),
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildRestaurantOrderCard(RestaurantOrder order) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.restaurant, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                Text(
                  order.restaurantName,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  'العنوان',
                  order.restaurantAddress,
                  Icons.location_on,
                ),
                _buildInfoRow(
                  'تاريخ الطلب',
                  formatDateTime(order.orderDate),
                  Icons.calendar_today,
                ),
                const SizedBox(height: 8),
                Text(
                  'الطلبات:',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: order.items.length,
                  itemBuilder: (context, index) {
                    final item = order.items[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            '${item.quantity} x ',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.cairo(),
                            ),
                          ),
                          Text(
                            '${item.price * item.quantity} \$',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildInfoRow(
                  'المبلغ الإجمالي',
                  '${order.totalPrice} دولار',
                  Icons.money,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(order.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusArabic(order.status),
                        style: GoogleFonts.cairo(
                          color: getStatusColor(order.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(order.paymentStatus)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusArabic(order.paymentStatus),
                        style: GoogleFonts.cairo(
                          color: getStatusColor(order.paymentStatus),
                          fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildCarBookingCard(CarBooking booking) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_car, color: Colors.teal, size: 24),
                const SizedBox(width: 8),
                Text(
                  '${booking.carMake} ${booking.carModel}',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(
                  'السعر اليومي',
                  '${booking.pricePerDay} دولار',
                  Icons.attach_money,
                ),
                _buildInfoRow(
                  'تاريخ الاستلام',
                  formatDateTime(booking.pickupDate),
                  Icons.calendar_today,
                ),
                _buildInfoRow(
                  'تاريخ التسليم',
                  formatDateTime(booking.returnDate),
                  Icons.calendar_today,
                ),
                _buildInfoRow(
                  'مكان الاستلام',
                  booking.pickupLocation,
                  Icons.location_on,
                ),
                _buildInfoRow(
                  'مكان التسليم',
                  booking.returnLocation,
                  Icons.location_on_outlined,
                ),
                _buildInfoRow(
                  'رقم رخصة القيادة',
                  booking.driverLicenseNumber,
                  Icons.credit_card,
                ),
                _buildInfoRow(
                  'السعر الإجمالي',
                  '${booking.totalPrice} دولار',
                  Icons.money,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(booking.status).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusArabic(booking.status),
                        style: GoogleFonts.cairo(
                          color: getStatusColor(booking.status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(booking.paymentStatus)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        getStatusArabic(booking.paymentStatus),
                        style: GoogleFonts.cairo(
                          color: getStatusColor(booking.paymentStatus),
                          fontWeight: FontWeight.bold,
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
    );
  }
} 
 