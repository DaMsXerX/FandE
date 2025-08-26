// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: MainScreen(),
//   ));
// }
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     Center(child: Text('Home Screen')),
//     Center(child: Text('Upload Screen')),
//     Center(child: Text('Profile Screen')),
//   ];
//
//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//         backgroundColor: Colors.white,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         showSelectedLabels: false,
//         showUnselectedLabels: false,
//         type: BottomNavigationBarType.fixed,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined, size: 30),
//             activeIcon: Icon(Icons.home, size: 30),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_box_outlined, size: 30),
//             activeIcon: Icon(Icons.add_box, size: 30),
//             label: 'Upload',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline, size: 30),
//             activeIcon: Icon(Icons.person, size: 30),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import '../controllers/auth_controller.dart';
import 'phone_auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: PhoneAuthScreen(),
    );
  }
}
