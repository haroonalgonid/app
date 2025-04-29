import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/Flights Screen/FlightBookingScreen.dart';
import 'screens/Hospitals Screens/hospitalHome_screen.dart';
import 'screens/Hotels Screens/hotel_screen.dart';
import 'screens/Reataurants Screens/cartProvider.dart';
import 'screens/Reataurants Screens/restaurant_screen.dart';
import 'screens/Settings Screens/Global.dart';
import 'screens/Settings Screens/Welcome_Screen.dart';
import 'screens/Settings Screens/login_screen.dart';
import 'screens/Transportations Screens/transportationHome_screen.dart';
import 'screens/NavigateBar.dart';

// التعامل مع الإشعارات في الخلفية
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // احصل على التوكن
  globalFcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $globalFcmToken");

  // التحقق مما إذا كانت شاشة الترحيب قد عرضت من قبل
  final prefs = await SharedPreferences.getInstance();
  final welcomeSeen = prefs.getBool('welcomeSeen') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // مزودين إضافيين هنا إذا لزم
      ],
      child: MyApp(initialRoute: welcomeSeen ? '/home' : '/welcome'),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // عند استلام الإشعار والتطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification Received in foreground:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });

    // عند فتح التطبيق من خلال الإشعار
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("User tapped on notification");
      // يمكنك توجيه المستخدم لصفحة معينة هنا
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.initialRoute,
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => const HomePage(),
        '/flight_tickets': (context) => const FlightBookingScreen(),
        '/hospitals': (context) => const HospitalsScreen(),
        '/hotels': (context) => const HotelsScreen(),
        '/restaurants': (context) => const RestaurantsScreen(),
        '/transportation': (context) => const CarCompaniesScreen(),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}