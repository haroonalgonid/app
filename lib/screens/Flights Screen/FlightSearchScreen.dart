import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'flightDetail_screen.dart';

// تعريف الألوان الأساسية
const mainColor = Color(0xFF2E7D32); // اللون الأخضر الأساسي
const secondaryColor = Color(0xFF4CAF50); // اللون الأخضر الثانوي
const backgroundColor = Color(0xFFF8FAFC);

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  _FlightSearchScreenState createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  DateTime? departureDate;
  List<dynamic> flights = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: const Text(
          'بحث عن رحلات',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildSearchSection(context),
              const SizedBox(height: 20),
              if (isLoading)
                const LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                )
              else if (flights.isNotEmpty)
                _buildFlightsList()
              else if (!isLoading && flights.isEmpty)
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.flight_takeoff,
                        size: 60,
                        color: mainColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'ابدأ البحث عن رحلتك',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
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
  }

  Widget _buildSearchSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTextInputField(
            label: 'من',
            icon: Icons.flight_takeoff,
            controller: _fromController,
            hint: 'أدخل مدينة المغادرة',
          ),
          const SizedBox(height: 15),
          _buildTextInputField(
            label: 'إلى',
            icon: Icons.flight_land,
            controller: _toController,
            hint: 'أدخل مدينة الوصول',
          ),
          const SizedBox(height: 15),
          _buildDatePicker(context),
          const SizedBox(height: 20),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildTextInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: mainColor,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: Icon(icon, color: mainColor, size: 22),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: mainColor.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: mainColor.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: mainColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: hint,
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: mainColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (selectedDate != null) {
          setState(() {
            departureDate = selectedDate;
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'تاريخ المغادرة',
            labelStyle: const TextStyle(
              color: mainColor,
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: mainColor,
              size: 22,
            ),
            hintText: departureDate == null
                ? 'اختر التاريخ'
                : DateFormat('yyyy-MM-dd').format(departureDate!),
            hintStyle: TextStyle(
              color: departureDate != null ? Colors.black87 : Colors.grey[400],
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: mainColor.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: mainColor.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: mainColor, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          enabled: false,
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () async {
          if (_fromController.text.isEmpty || _toController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('الرجاء إدخال مدينتي المغادرة والوصول'),
                backgroundColor: Colors.red[400],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else {
            await _searchFlights();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: mainColor),
          ),
          elevation: 2,
        ),
        child: const Text(
          'ابحث عن رحلات',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _searchFlights() async {
    setState(() {
      isLoading = true;
    });

    try {
      final formattedDate = departureDate != null
          ? DateFormat('yyyy-MM-dd').format(departureDate!)
          : null;
      final url = Uri.parse(
        'https://backend-fpnx.onrender.com/flights/flights?departureAirport=${_fromController.text}&arrivalAirport=${_toController.text}&departureDate=$formattedDate',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          flights = json.decode(response.body);
          isLoading = false;
        });
      } else {
        _showErrorSnackBar('لم يتم العثور على رحلات لهذا البحث');
      }
    } catch (e) {
      _showErrorSnackBar('حدث خطأ في الاتصال');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildFlightsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flights.length,
      itemBuilder: (context, index) {
        final flight = flights[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.white, mainColor.withOpacity(0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flight, color: mainColor, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'رقم الرحلة: ${flight['flightNumber'] ?? 'غير معروف'}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: mainColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'السعر: \$${flight['priceEconomy'] ?? 'غير معروف'}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'من',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${flight['departureAirport'] ?? 'غير معروف'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child:
                            const Icon(Icons.arrow_forward, color: mainColor),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'إلى',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${flight['arrivalAirport'] ?? 'غير معروف'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'التاريخ: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(flight['departureDate'] ?? DateTime.now().toIso8601String()))}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FlightDetailScreen(flightId: flight["_id"]),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          'التفاصيل',
                          style: TextStyle(
                            color: Colors.white,
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
        );
      },
    );
  }
}
