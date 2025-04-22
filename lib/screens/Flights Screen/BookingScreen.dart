import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/flight_service.dart';
import '../../theme/color.dart';
import 'flightDetail_screen.dart';
import 'seat_screen.dart';

class FlightBookingScreen extends StatefulWidget {
  final String flightId;

  const FlightBookingScreen({super.key, required this.flightId});

  @override
  State<FlightBookingScreen> createState() => _FlightBookingScreenState();
}

class _FlightBookingScreenState extends State<FlightBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _seatNumberController = TextEditingController();
  final _passportNumberController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'حجز الرحلة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          backgroundColor: AppTheme.mainGreen,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'معلومات الحجز',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.mainGreen,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _seatNumberController,
                            decoration: InputDecoration(
                              labelText: 'رقم المقعد',
                              prefixIcon: const Icon(
                                  Icons.airline_seat_recline_normal,
                                  color: AppTheme.mainGreen),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppTheme.mainGreen),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppTheme.mainGreen),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال رقم المقعد';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passportNumberController,
                            decoration: InputDecoration(
                              labelText: 'رقم الجواز',
                              prefixIcon: const Icon(Icons.document_scanner,
                                  color: AppTheme.mainGreen),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: AppTheme.mainGreen),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال رقم الجواز';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.mainGreen),
                          )
                        : Column(
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final selectedSeat = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SeatMapScreen(
                                          flightId: widget.flightId),
                                    ),
                                  );

                                  if (selectedSeat != null) {
                                    setState(() {
                                      _seatNumberController.text = selectedSeat;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                        Icons
                                            .airline_seat_recline_normal_outlined,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      'عرض خريطة المقاعد',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: _submitBooking,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.mainGreen,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 5,
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(
                                      'تأكيد الحجز',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final bookingData = {
        "flight": widget.flightId,
        "seatNumber": _seatNumberController.text,
        "passportNumber": _passportNumberController.text,
      };

      try {
        await FlightService.bookFlight(bookingData);
        Get.snackbar(
          'نجاح',
          'تم حجز الرحلة بنجاح!',
          icon: const Icon(Icons.check_circle, color: Colors.green),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
        );
        Navigator.pop(context);
      } catch (e) {
        Get.snackbar(
          'خطأ',
          ' ${e.toString()}',
          icon: const Icon(Icons.warning, color: Colors.red),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
          duration: const Duration(seconds: 3),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}