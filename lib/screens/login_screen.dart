// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';
// import 'signup_screen.dart';
//
// class LoginScreen extends StatelessWidget {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final AuthController authController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
//             TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
//             ElevatedButton(
//               onPressed: () {
//                 authController.login(
//                   emailController.text.trim(),
//                   passwordController.text.trim(),
//                 );
//               },
//               child: Text("Login"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Get.to(() => SignupScreen());
//               },
//               child: Text("Don't have an account? Sign up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
