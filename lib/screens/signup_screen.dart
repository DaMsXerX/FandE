// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';
//
// class SignupScreen extends StatelessWidget {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final usernameController = TextEditingController();
//   final AuthController authController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up')),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           children: [
//             TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
//             TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
//             TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
//             ElevatedButton(
//               onPressed: () {
//                 authController.register(
//                   emailController.text.trim(),
//                   passwordController.text.trim(),
//                   usernameController.text.trim(),
//                 );
//               },
//               child: Text("Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
