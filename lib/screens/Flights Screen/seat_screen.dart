import 'package:flutter/material.dart';
import '../../service/flight_service.dart';
import '../../theme/color.dart';
import 'flightDetail_screen.dart';

class SeatMapScreen extends StatefulWidget {
  final String flightId;

  const SeatMapScreen({super.key, required this.flightId});

  @override
  _SeatMapScreenState createState() => _SeatMapScreenState();
}

class _SeatMapScreenState extends State<SeatMapScreen> {
  List<Map<String, dynamic>> availableSeats = [];
  bool isLoading = true;
  String? errorMessage;
  String? selectedSeat;

  @override
  void initState() {
    super.initState();
    fetchSeats();
  }

  Future<void> fetchSeats() async {
    try {
      final seats = await FlightService.fetchAvailableSeats(widget.flightId);
      setState(() {
        availableSeats = List<Map<String, dynamic>>.from(seats);
        isLoading = false;
      });
    } catch (e) {
      print('API Error: $e'); // طباعة الخطأ في الترمينال
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  void _selectSeat(String seatNumber) {
    setState(() {
      selectedSeat = seatNumber;
    });
    // إظهار نافذة تأكيد اختيار المقعد
    _showSeatConfirmationDialog(seatNumber);
  }

 void _showSeatConfirmationDialog(String seatNumber) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تأكيد اختيار المقعد'),
          content: Text('هل تريد اختيار المقعد رقم $seatNumber؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الحوار
              },
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.mainGreen,
              ),
              onPressed: () {
                Navigator.pop(context); // إغلاق الحوار
                Navigator.pop(context, seatNumber); // العودة إلى الشاشة السابقة مع إرسال رقم المقعد
              },
              child: Text('تأكيد', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'خريطة المقاعد المتاحة',
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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
                ? Center(child: Text('حدث خطأ: $errorMessage'))
                : availableSeats.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد مقاعد متاحة حاليًا 🪑',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'اختر مقعدك',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.mainGreen,
                              ),
                            ),
                          ),
                          // قسم للإشارة إلى الأمام
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '⬅️ مقدمة الطائرة',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // خريطة المقاعد
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: availableSeats.length,
                                itemBuilder: (context, index) {
                                  final seat = availableSeats[index];
                                  final seatNumber = seat['seatNumber'].toString();
                                  final seatClass = seat['class'] ?? 'Economy';
                                  
                                  // تحديد لون المقعد بناءً على الفئة
                                  Color seatColor;
                                  switch (seatClass) {
                                    case 'Business':
                                      seatColor = Colors.blue;
                                      break;
                                    case 'FirstClass':
                                      seatColor = Colors.purple;
                                      break;
                                    default:
                                      seatColor = AppTheme.mainGreen;
                                  }
                                  
                                  // التحقق مما إذا كان هذا المقعد محددًا
                                  final isSelected = selectedSeat == seatNumber;
                                  
                                  return GestureDetector(
                                    onTap: () {
                                      _selectSeat(seatNumber);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.amber : seatColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.3),
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                )
                                              ]
                                            : null,
                                      ),
                                      child: Stack(
                                        children: [
                                          // أيقونة المقعد
                                          Center(
                                            child: Icon(
                                              Icons.event_seat,
                                              color: Colors.white.withOpacity(0.7),
                                              size: 28,
                                            ),
                                          ),
                                          // رقم المقعد
                                          Center(
                                            child: Text(
                                              seatNumber,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          // مفتاح تفسيري للألوان
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildLegendItem(AppTheme.mainGreen, 'اقتصادية'),
                                _buildLegendItem(Colors.blue, 'رجال أعمال'),
                                _buildLegendItem(Colors.purple, 'درجة أولى'),
                                _buildLegendItem(Colors.amber, 'محدد'),
                              ],
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}