import 'dart:async'; // Required for Timer
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX
import 'package:fande/screens/profile_screen.dart';

import 'login_screen.dart'; // Import your login screen
import 'phone_auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Preload the background image
      await precacheImage(const AssetImage('images/FE.png'), context);

      // Delay for splash duration
      await Future.delayed(const Duration(seconds: 2));

      // Navigate based on login status
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.off(() => ProfileScreen());
      } else {
        Get.off(() => PhoneAuthScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/FE.png', // Path to your image
              fit: BoxFit.cover, // Ensures the image covers the entire screen
            ),
          ),
          // Gradient Overlay (optional, for better text visibility)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0), // Darker at top
                    Colors.white10.withOpacity(0.0), // Darker at bottom
                  ],
                ),
              ),
            ),
          ),
          // Centered Text "TikStar"
          // const Center(
          //   child: Text(
          //     'F&E',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontSize: 48,
          //       fontWeight: FontWeight.bold,
          //       // You can add more styling like fontFamily if you have custom fonts
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}