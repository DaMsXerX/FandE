import 'package:fande/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; // <-- Add this
import 'controllers/auth_controller.dart';
import 'controllers/reel_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode
        ? AndroidProvider.debug
        : AndroidProvider.debug, // TEMP: Use debug for release too while testing
  );


  // Inject AuthController with GetX
  Get.put(AuthController());
  Get.put(ReelController());
  Get.put(RouteObserver<PageRoute<dynamic>>());


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      home: SplashScreen(),
    );
  }
}
