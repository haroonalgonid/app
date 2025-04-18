import 'package:flutter/material.dart';
import '../../service/flight_service.dart';
import '../../theme/color.dart';
import 'BookingScreen.dart';

// تعريف ألوان التطبيق الجديدة
class AppTheme {
  static const mainGreen = Color(0xFF2E7D32);
  static const lightGreen = Color(0xFFAED581);
  static const darkGreen = Color(0xFF1B5E20);
  static const background = Color(0xFFF5F9F6);
  static const cardBackground = Colors.white;
  static const textDark = Color(0xFF263238);
  static const textLight = Color(0xFF546E7A);
  static const accentColor = Color(0xFFFF6D00);
}

class FlightDetailScreen extends StatefulWidget {
  final String flightId;

  const FlightDetailScreen({super.key, required this.flightId});

  @override
  State<FlightDetailScreen> createState() => _FlightDetailScreenState();
}

class _FlightDetailScreenState extends State<FlightDetailScreen> {
  Map<String, dynamic>? _flightDetails;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFlightDetails();
  }

  Future<void> _fetchFlightDetails() async {
    try {
      final data = await FlightService.fetchFlightDetails(widget.flightId);
      setState(() {
        _flightDetails = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل تفاصيل الرحلة';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6FA),
        appBar: AppBar(
          title: const Text(
            'تفاصيل الرحلة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.mainGreen,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.mainGreen,
                ),
              )
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppTheme.accentColor,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchFlightDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.mainGreen,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                : _flightDetails != null
                    ? _buildFlightDetailsContent()
                    : const Center(
                        child: Text(
                          'لا توجد بيانات',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppTheme.textDark,
                          ),
                        ),
                      ),
      ),
    );
  }

  Widget _buildFlightDetailsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFlightHeader(_flightDetails!),
          const SizedBox(height: 20),
          _buildFlightInfo(_flightDetails!),
          const SizedBox(height: 20),
          _buildPriceInfo(_flightDetails!),
          const SizedBox(height: 20),
          _buildSeatInfo(_flightDetails!),
          const SizedBox(height: 30),
          _buildBookingButton(),
        ],
      ),
    );
  }
Widget _buildFlightHeader(Map<String, dynamic> flight) {
  String formatDateTime(String isoTime) {
    final dateTime = DateTime.parse(isoTime);
    final date = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date\n$time';
  }

  return Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppTheme.mainGreen, AppTheme.lightGreen],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: AppTheme.mainGreen.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAirportColumn('مطار المغادرة', flight['departureAirport']),
            Column(
              children: [
                const Icon(Icons.flight, color: Colors.white, size: 30),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 1,
                  width: 80,
                  color: Colors.white70,
                ),
                Text(
                  'رحلة ${flight['flightNumber']}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            _buildAirportColumn('مطار الوصول', flight['arrivalAirport']),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDateTimeColumn('المغادرة', formatDateTime(flight['departureTime'])),
            Text(
              _getFlightStatus(flight['status']),
              style: TextStyle(
                color: _getStatusColor(flight['status']),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildDateTimeColumn('الوصول', formatDateTime(flight['arrivalTime'])),
          ],
        ),
      ],
    ),
  );
}

Widget _buildDateTimeColumn(String title, String dateTime) {
  final parts = dateTime.split('\n');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      const SizedBox(height: 5),
      Text(
        parts[1], // الوقت
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        parts[0], // التاريخ
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    ],
  );
}

Widget _buildAirportColumn(String title, String airportName) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      const SizedBox(height: 5),
      // Text(
      //   _getAirportCode(airportName),
      //   style: const TextStyle(
      //     color: Colors.white,
      //     fontSize: 28,
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
      Text(airportName, style: const TextStyle(color: Colors.white, fontSize: 16)),
    ],
  );
}

Widget _buildTimeColumn(String title, String time) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      const SizedBox(height: 5),
      Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}


  Widget _buildFlightInfo(Map<String, dynamic> flight) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppTheme.lightGreen.withOpacity(0.5), width: 1),
      ),
      color: AppTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.mainGreen, size: 20),
                SizedBox(width: 10),
                Text(
                  'معلومات الرحلة',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const Divider(color: AppTheme.lightGreen, height: 30),
            _buildInfoRow('رقم الرحلة', flight['flightNumber']),
            _buildInfoRow('نوع الطائرة', flight['aircraftType']),
            _buildInfoRow('حالة الرحلة', flight['status']),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(Map<String, dynamic> flight) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppTheme.lightGreen.withOpacity(0.5), width: 1),
      ),
      color: AppTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.attach_money, color: AppTheme.mainGreen, size: 20),
                SizedBox(width: 10),
                Text(
                  'الفئات السعرية',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const Divider(color: AppTheme.lightGreen, height: 30),
            _buildPriceRow('الاقتصادية', '\$${flight['priceEconomy']}'),
            _buildPriceRow('رجال الأعمال', '\$${flight['priceBusiness']}'),
            _buildPriceRow('الأولى', '\$${flight['priceFirstClass']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatInfo(Map<String, dynamic> flight) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: AppTheme.lightGreen.withOpacity(0.5), width: 1),
      ),
      color: AppTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.event_seat, color: AppTheme.mainGreen, size: 20),
                SizedBox(width: 10),
                Text(
                  'المقاعد المتاحة',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
              ],
            ),
            const Divider(color: AppTheme.lightGreen, height: 30),
            _buildSeatRow('الاقتصادية', flight['availableSeatsEconomy'].toString()),
            _buildSeatRow('رجال الأعمال', flight['availableSeatsBusiness'].toString()),
            _buildSeatRow('الأولى', flight['availableSeatsFirstClass'].toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textLight,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textLight,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.mainGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textLight,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.chair_alt,
                color: AppTheme.mainGreen,
                size: 20,
              ),
              const SizedBox(width: 5),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingButton() {
    return Center(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.mainGreen.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlightBookingScreen(
                  flightId: widget.flightId,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.mainGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.airplane_ticket, size: 22),
              SizedBox(width: 10),
              Text(
                'حجز الرحلة الآن',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // String _getAirportCode(String airportName) {
  //   final words = airportName.split(' ');
  //   if (words.length > 1) {
  //     return '${words[0][0]}${words[1][0]}${words.length > 2 ? words[2][0] : ''}';
  //   }
  //   return words[0].substring(0, min(3, words[0].length)).toUpperCase();
  // }

  int min(int a, int b) => a < b ? a : b;

  String _getFlightStatus(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'مجدولة';
      case 'delayed':
        return 'متأخرة';
      case 'boarding':
        return 'بدء الصعود';
      case 'in-air':
        return 'في الجو';
      case 'landed':
        return 'هبطت';
      case 'cancelled':
        return 'ملغاة';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.white;
      case 'boarding':
        return Colors.amber;
      case 'in-air':
        return Colors.lightBlueAccent;
      case 'landed':
        return Colors.green;
      case 'delayed':
        return Colors.deepOrange;
      case 'cancelled':
        return Colors.redAccent;
      default:
        return Colors.white;
    }
  }
}