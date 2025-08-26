// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../screens/login_screen.dart';
// import '../screens/profile_screen.dart';
//
// class AuthController extends GetxController {
//   static AuthController instance = Get.find();
//   late Rx<User?> firebaseUser;
//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   @override
//   void onReady() {
//     super.onReady();
//     firebaseUser = Rx<User?>(auth.currentUser);
//     firebaseUser.bindStream(auth.userChanges());
//     ever(firebaseUser, _setInitialScreen);
//   }
//
//   _setInitialScreen(User? user) {
//     if (user == null) {
//       Get.offAll(() => LoginScreen());
//     } else {
//       Get.offAll(() => ProfileScreen());
//     }
//   }
//
//   void register(String email, String password, String username) async {
//     try {
//       UserCredential cred = await auth.createUserWithEmailAndPassword(
//           email: email, password: password);
//
//       await firestore.collection("users").doc(cred.user!.uid).set({
//         'email': email,
//         'username': username,
//         'uid': cred.user!.uid,
//       });
//
//       Get.snackbar("Success", "Account created!");
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     }
//   }
//
//   void login(String email, String password) async {
//     try {
//       await auth.signInWithEmailAndPassword(email: email, password: password);
//     } catch (e) {
//       Get.snackbar("Login Failed", e.toString());
//     }
//   }
//
//   void logout() async {
//     await auth.signOut();
//   }
// }








//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
// import '../screens/complete_profile_screen.dart';
// import '../screens/profile_screen.dart';
//
// class AuthController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   late String _verificationId;
//
//   /// ✅ Add this getter so it can be accessed outside this class
//   FirebaseAuth get auth => _auth;
//
//   Future<void> verifyPhone(String phoneNumber) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         _handlePostLogin(_auth.currentUser);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         Get.snackbar("Error", e.message ?? "Verification Failed");
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId;
//         Get.snackbar("OTP Sent", "Please check your phone");
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }
//
//   void verifyOtp(String otp) async {
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId,
//         smsCode: otp,
//       );
//       final result = await _auth.signInWithCredential(credential);
//       final user = result.user;
//       if (user != null) {
//         _handlePostLogin(user);
//       }
//     } catch (e) {
//       Get.snackbar("Error", "Invalid OTP");
//     }
//   }
//
//   Future<String> getUserName(String uid) async {
//     try {
//       final doc = await _firestore.collection("users").doc(uid).get();
//       return doc.data()?['username'] ?? 'Unknown';
//     } catch (e) {
//       return 'Unknown';
//     }
//   }
//
//
//   void logout() async {
//      await auth.signOut();
//    }
//
//
//   void _handlePostLogin(User? user) async {
//     if (user == null) return;
//
//     final doc = await _firestore.collection("users").doc(user.uid).get();
//
//     if (!doc.exists || doc.data()?['username'] == null) {
//       Get.offAll(() => CompleteProfileScreen(user: user));
//     } else {
//       Get.offAll(() => ProfileScreen());
//     }
//   }
// }




//this is working before updated phone auth

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../screens/complete_profile_screen.dart';
// import '../screens/profile_screen.dart';
//
// class AuthController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   late String _verificationId;
//
//   /// ✅ Public getter for FirebaseAuth
//   FirebaseAuth get auth => _auth;
//
//   /// ✅ Helper function for consistent styled Snackbars
//   void _showSnackbar(String title, String message) {
//     Get.snackbar(
//       title,
//       message,
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.grey[800],
//       colorText: Colors.white,
//     );
//   }
//
//   Future<void> verifyPhone(String phoneNumber) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         _handlePostLogin(_auth.currentUser);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         _showSnackbar("Error", e.message ?? "Verification Failed");
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId;
//         _showSnackbar("OTP Sent", "Please check your phone");
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }
//
//   void verifyOtp(String otp) async {
//     try {
//       final credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId,
//         smsCode: otp,
//       );
//       final result = await _auth.signInWithCredential(credential);
//       final user = result.user;
//       if (user != null) {
//         _handlePostLogin(user);
//       }
//     } catch (e) {
//       _showSnackbar("Error", "Invalid OTP");
//     }
//   }
//
//   Future<String> getUserName(String uid) async {
//     try {
//       final doc = await _firestore.collection("users").doc(uid).get();
//       return doc.data()?['username'] ?? 'Unknown';
//     } catch (e) {
//       return 'Unknown';
//     }
//   }
//
//   void logout() async {
//     await auth.signOut();
//   }
//
//   void _handlePostLogin(User? user) async {
//     if (user == null) return;
//
//     final doc = await _firestore.collection("users").doc(user.uid).get();
//
//     if (!doc.exists || doc.data()?['username'] == null) {
//       Get.offAll(() => CompleteProfileScreen(user: user));
//     } else {
//       Get.offAll(() => ProfileScreen());
//     }
//   }
// }






import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/complete_profile_screen.dart';
import '../screens/profile_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _verificationId;
  String? _currentPhoneNumber;

  // Reactive variables for UI state management
  final RxBool isLoading = false.obs;
  final RxBool isOtpVerifying = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString successMessage = ''.obs;

  /// ✅ Public getter for FirebaseAuth
  FirebaseAuth get auth => _auth;

  /// ✅ Get current phone number
  String? get currentPhoneNumber => _currentPhoneNumber;

  /// ✅ Enhanced Snackbar with different types
  void _showSnackbar(String title, String message, {SnackbarType type = SnackbarType.normal}) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData? icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green.withOpacity(0.9);
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red.withOpacity(0.9);
        icon = Icons.error;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange.withOpacity(0.9);
        icon = Icons.warning;
        break;
      case SnackbarType.info:
        backgroundColor = Colors.blue.withOpacity(0.9);
        icon = Icons.info;
        break;
      default:
        backgroundColor = Colors.grey[800]!;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: icon != null ? Icon(icon, color: textColor) : null,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  /// ✅ Enhanced phone verification with better error handling
  Future<void> verifyPhone(String phoneNumber) async {
    try {
      // Validate phone number format
      if (!_isValidPhoneNumber(phoneNumber)) {
        throw Exception("Please enter a valid phone number");
      }

      isLoading.value = true;
      errorMessage.value = '';
      _currentPhoneNumber = phoneNumber;

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            isLoading.value = false;
            _showSnackbar("Success", "Phone verified automatically!", type: SnackbarType.success);
            _handlePostLogin(_auth.currentUser);
          } catch (e) {
            isLoading.value = false;
            _handleAuthError(e);
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          _handleFirebaseAuthError(e);
        },

        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          isLoading.value = false;
          successMessage.value = "OTP sent successfully!";
          _showSnackbar("OTP Sent", "Please check your phone for the verification code", type: SnackbarType.success);
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          isLoading.value = false;
        },
      );
    } catch (e) {
      isLoading.value = false;
      _handleAuthError(e);
    }
  }

  /// ✅ Enhanced OTP verification with better error handling
  Future<void> verifyOtp(String otp) async {
    try {
      // Validate OTP format
      if (!_isValidOtp(otp)) {
        throw Exception("Please enter a valid 6-digit OTP");
      }

      isOtpVerifying.value = true;
      errorMessage.value = '';

      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;

      if (user != null) {
        isOtpVerifying.value = false;
        _showSnackbar("Success", "Login successful!", type: SnackbarType.success);
        await _handlePostLogin(user);
      } else {
        throw Exception("Authentication failed. Please try again.");
      }
    } on FirebaseAuthException catch (e) {
      isOtpVerifying.value = false;
      _handleFirebaseAuthError(e);
    } catch (e) {
      isOtpVerifying.value = false;
      _handleAuthError(e);
    }
  }

  /// ✅ Resend OTP functionality
  Future<void> resendOtp() async {
    if (_currentPhoneNumber != null) {
      await verifyPhone(_currentPhoneNumber!);
    } else {
      _showSnackbar("Error", "Phone number not found. Please restart the process.", type: SnackbarType.error);
    }
  }

  /// ✅ Enhanced user data retrieval
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  /// ✅ Get username (backward compatibility)
  Future<String> getUserName(String uid) async {
    try {
      final userData = await getUserData(uid);
      return userData?['username'] ?? 'Unknown';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// ✅ Enhanced logout with cleanup
  Future<void> logout() async {
    try {
      await _auth.signOut();
      _currentPhoneNumber = null;
      isLoading.value = false;
      isOtpVerifying.value = false;
      errorMessage.value = '';
      successMessage.value = '';
      _showSnackbar("Logged Out", "You have been successfully logged out", type: SnackbarType.info);
    } catch (e) {
      _showSnackbar("Error", "Failed to logout. Please try again.", type: SnackbarType.error);
    }
  }

  /// ✅ Check if user is already logged in
  bool get isLoggedIn => _auth.currentUser != null;

  /// ✅ Get current user
  User? get currentUser => _auth.currentUser;

  /// ✅ Enhanced post-login handling with better error management
  Future<void> _handlePostLogin(User? user) async {
    if (user == null) return;

    try {
      final doc = await _firestore.collection("users").doc(user.uid).get();

      if (!doc.exists || doc.data()?['username'] == null || doc.data()?['username'] == '') {
        // User needs to complete profile
        Get.offAll(() => CompleteProfileScreen(user: user));
      } else {
        // User profile is complete, go to main screen
        Get.offAll(() => ProfileScreen());
      }
    } catch (e) {
      // If there's an error fetching user data, assume profile needs completion
      print("Error checking user profile: $e");
      Get.offAll(() => CompleteProfileScreen(user: user));
    }
  }

  /// ✅ Validate phone number format
  bool _isValidPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Check if phone number has reasonable length (10-15 digits)
    return digitsOnly.length >= 10 && digitsOnly.length <= 15;
  }

  /// ✅ Validate OTP format
  bool _isValidOtp(String otp) {
    // Check if OTP is exactly 6 digits
    return otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);
  }

  /// ✅ Handle Firebase Auth specific errors
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    String errorMsg;

    switch (e.code) {
      case 'invalid-phone-number':
        errorMsg = "Invalid phone number format";
        break;
      case 'too-many-requests':
        errorMsg = "Too many attempts. Please try again later";
        break;
      case 'invalid-verification-code':
        errorMsg = "Invalid verification code. Please check and try again";
        break;
      case 'session-expired':
        errorMsg = "Verification session expired. Please request a new code";
        break;
      case 'quota-exceeded':
        errorMsg = "SMS quota exceeded. Please try again later";
        break;
      case 'missing-phone-number':
        errorMsg = "Phone number is required";
        break;
      case 'missing-verification-code':
        errorMsg = "Verification code is required";
        break;
      case 'invalid-verification-id':
        errorMsg = "Invalid verification session. Please restart the process";
        break;
      default:
        errorMsg = e.message ?? "Authentication failed. Please try again";
    }

    errorMessage.value = errorMsg;
    _showSnackbar("Authentication Error", errorMsg, type: SnackbarType.error);
  }

  /// ✅ Handle general errors
  void _handleAuthError(dynamic error) {
    String errorMsg = error.toString().replaceFirst('Exception: ', '');
    errorMessage.value = errorMsg;
    _showSnackbar("Error", errorMsg, type: SnackbarType.error);
  }

  /// ✅ Clear error messages
  void clearErrors() {
    errorMessage.value = '';
    successMessage.value = '';
  }

  /// ✅ Check authentication state changes
  @override
  void onInit() {
    super.onInit();

    // Listen to auth state changes
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in: ${user.phoneNumber}');
      }
    });
  }
}

/// ✅ Enum for different snackbar types
enum SnackbarType {
  normal,
  success,
  error,
  warning,
  info,
}