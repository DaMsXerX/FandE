// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:async';
// import '../controllers/auth_controller.dart';
//
// class PhoneAuthScreen extends StatefulWidget {
//   @override
//   _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
// }
//
// class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
//   final AuthController authController = Get.find();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//
//   String selectedCountryCode = '+91';
//   bool otpSent = false;
//   bool isSendingOtp = false;
//   int resendCooldown = 0;
//   Timer? cooldownTimer;
//
//   final List<String> countryCodes = ['+91', '+1', '+44', '+61', '+971'];
//
//   void startCooldown() {
//     setState(() {
//       resendCooldown = 30;
//     });
//
//     cooldownTimer?.cancel();
//     cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       setState(() {
//         resendCooldown--;
//         if (resendCooldown <= 0) {
//           cooldownTimer?.cancel();
//         }
//       });
//     });
//   }
//
//   Future<void> handleSendOtp() async {
//     setState(() {
//       isSendingOtp = true;
//     });
//
//     final fullPhone = selectedCountryCode + phoneController.text.trim();
//
//     try {
//       await authController.verifyPhone(fullPhone);
//       setState(() {
//         otpSent = true;
//         isSendingOtp = false;
//       });
//       startCooldown();
//       Get.snackbar(
//         "Success",
//         "OTP has been initiated, please wait",
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.grey[800],
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       setState(() {
//         isSendingOtp = false;
//       });
//       Get.snackbar(
//         "Error",
//         "Failed to send OTP",
//         snackPosition: SnackPosition.TOP,
//         backgroundColor: Colors.grey[800],
//         colorText: Colors.white,
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     cooldownTimer?.cancel();
//     phoneController.dispose();
//     otpController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: const Text(
//           "Phone Authentication",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 40),
//                 const Text(
//                   "Enter your phone number",
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.grey[900],
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           dropdownColor: Colors.grey[900],
//                           style: const TextStyle(color: Colors.white),
//                           value: selectedCountryCode,
//                           items: countryCodes.map((code) {
//                             return DropdownMenuItem(
//                               value: code,
//                               child: Text(code),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() {
//                                 selectedCountryCode = value;
//                               });
//                             }
//                           },
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: phoneController,
//                         keyboardType: TextInputType.phone,
//                         style: const TextStyle(color: Colors.white),
//                         decoration: InputDecoration(
//                           labelText: "Phone Number",
//                           labelStyle: const TextStyle(color: Colors.white70),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.grey.shade700),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: const BorderSide(color: Colors.blueAccent),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton.icon(
//                   onPressed: isSendingOtp || resendCooldown > 0
//                       ? null
//                       : handleSendOtp,
//                   icon: isSendingOtp
//                       ? const SizedBox(
//                     height: 18,
//                     width: 18,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Colors.white,
//                     ),
//                   )
//                       : const Icon(Icons.send),
//                   label: Text(
//                     resendCooldown > 0
//                         ? "Resend OTP in $resendCooldown"
//                         : "Send OTP",
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     textStyle: const TextStyle(fontSize: 16),
//                     backgroundColor: Colors.blueAccent,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 if (otpSent) ...[
//                   const Text(
//                     "Enter the OTP sent to your number",
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: otpController,
//                     keyboardType: TextInputType.number,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: "OTP",
//                       labelStyle: const TextStyle(color: Colors.white70),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.grey.shade700),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.blueAccent),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       authController.verifyOtp(otpController.text.trim());
//                     },
//                     icon: const Icon(Icons.lock_open),
//                     label: const Text("Verify OTP & Login"),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       textStyle: const TextStyle(fontSize: 16),
//                       backgroundColor: Colors.blueAccent,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../controllers/auth_controller.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  PhoneAuthScreenState createState() => PhoneAuthScreenState();
}

class PhoneAuthScreenState extends State<PhoneAuthScreen>
    with TickerProviderStateMixin {
  final AuthController authController = Get.find();
  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers =
  List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  String selectedCountryCode = '+91';
  String selectedCountryFlag = '🇮🇳';
  bool otpSent = false;
  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  int resendCooldown = 0;
  int otpExpiryTime = 300; // 5 minutes
  Timer? cooldownTimer;
  Timer? otpExpiryTimer;

  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  final Map<String, String> countryData = {
    '+91': '🇮🇳',
    '+1': '🇺🇸',
    '+44': '🇬🇧',
    '+61': '🇦🇺',
    '+971': '🇦🇪',
    '+49': '🇩🇪',
    '+33': '🇫🇷',
    '+86': '🇨🇳',
    '+81': '🇯🇵',
    '+82': '🇰🇷',
  };

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    phoneController.addListener(_onPhoneNumberChanged);
  }

  void _onPhoneNumberChanged() {
    String text = phoneController.text;
    String formatted = _formatPhoneNumber(text);
    if (formatted != text) {
      phoneController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String _formatPhoneNumber(String phone) {
    String digits = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (selectedCountryCode == '+1') {
      // US format: (123) 456-7890
      if (digits.length >= 6) {
        return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
      } else if (digits.length >= 3) {
        return '(${digits.substring(0, 3)}) ${digits.substring(3)}';
      }
    } else if (selectedCountryCode == '+91') {
      // India format: 12345 67890
      if (digits.length > 5) {
        return '${digits.substring(0, 5)} ${digits.substring(5)}';
      }
    }

    return digits;
  }

  void startCooldown() {
    setState(() {
      resendCooldown = 30;
      otpExpiryTime = 300;
    });

    cooldownTimer?.cancel();
    cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        resendCooldown--;
        if (resendCooldown <= 0) {
          cooldownTimer?.cancel();
        }
      });
    });

    otpExpiryTimer?.cancel();
    otpExpiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        otpExpiryTime--;
        if (otpExpiryTime <= 0) {
          otpExpiryTimer?.cancel();
          _handleOtpExpiry();
        }
      });
    });
  }

  void _handleOtpExpiry() {
    setState(() {
      otpSent = false;
      for (var controller in otpControllers) {
        controller.clear();
      }
    });

    Get.snackbar(
      "OTP Expired",
      "Please request a new OTP",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange.withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.timer_off, color: Colors.white),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> handleSendOtp() async {
    if (phoneController.text.trim().isEmpty) {
      _showErrorSnackbar("Please enter your phone number");
      return;
    }

    setState(() {
      isSendingOtp = true;
    });

    _pulseController.repeat(reverse: true);

    final fullPhone = selectedCountryCode + phoneController.text.replaceAll(RegExp(r'[^\d]'), '');

    try {
      await authController.verifyPhone(fullPhone);
      setState(() {
        otpSent = true;
        isSendingOtp = false;
      });

      _pulseController.stop();
      _slideController.forward();
      startCooldown();

      _showNormalSnackbar("Otp will be sent shortly");

      // Auto focus first OTP field
      Future.delayed(const Duration(milliseconds: 500), () {
        otpFocusNodes[0].requestFocus();
      });

    } catch (e) {
      setState(() {
        isSendingOtp = false;
      });
      _pulseController.stop();
      _showErrorSnackbar("Failed to send OTP. Please try again.");
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all fields are filled
    if (index == 5 && value.isNotEmpty) {
      String otp = otpControllers.map((c) => c.text).join();
      if (otp.length == 6) {
        _verifyOtp();
      }
    }
  }

  void _verifyOtp() async {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      _showErrorSnackbar("Please enter complete OTP");
      return;
    }

    setState(() {
      isVerifyingOtp = true;
    });

    try {
      await authController.verifyOtp(otp);
      // _showSuccessSnackbar("Login successful!");
    } catch (e) {
      setState(() {
        isVerifyingOtp = false;
      });
      _showErrorSnackbar("Invalid OTP. Please try again.");
      // Clear OTP fields on error
      for (var controller in otpControllers) {
        controller.clear();
      }
      otpFocusNodes[0].requestFocus();
    }
  }

  void _showNormalSnackbar(String message) {
    Get.snackbar(
      "Wait!",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    cooldownTimer?.cancel();
    otpExpiryTimer?.cancel();
    _slideController.dispose();
    _pulseController.dispose();
    phoneController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in otpFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 50),

                  // Phone Input Section
                  _buildPhoneInputSection(),

                  // OTP Section
                  if (otpSent) ...[
                    const SizedBox(height: 40),
                    SlideTransition(
                      position: _slideAnimation,
                      child: _buildOtpSection(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.3),
                Colors.purpleAccent.withOpacity(0.3),
              ],
            ),
          ),
          child: const Icon(
            Icons.smartphone,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Phone Verification",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          otpSent
              ? "Enter the 6-digit code sent to your phone"
              : "We'll send you a verification code",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPhoneInputSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Phone Number",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Country Code Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    value: selectedCountryCode,
                    items: countryData.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(entry.value, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(entry.key),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCountryCode = value;
                          selectedCountryFlag = countryData[value]!;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Phone Input
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d\s\(\)\-]')),
                    ],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Send OTP Button
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isSendingOtp ? _pulseAnimation.value : 1.0,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isSendingOtp || resendCooldown > 0
                        ? null
                        : handleSendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: resendCooldown > 0
                          ? Colors.grey[700]
                          : Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: isSendingOtp
                        ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "Sending...",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                        : Text(
                      resendCooldown > 0
                          ? "Resend in ${resendCooldown}s"
                          : otpSent
                          ? "Resend OTP"
                          : "Send OTP",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Verification Code",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: otpExpiryTime > 60
                      ? Colors.green.withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatTime(otpExpiryTime),
                  style: TextStyle(
                    color: otpExpiryTime > 60 ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // OTP Input Fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return Container(
                width: 45,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: otpControllers[index].text.isNotEmpty
                        ? Colors.blueAccent
                        : Colors.grey[700]!,
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: otpControllers[index],
                  focusNode: otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (value) => _onOtpChanged(index, value),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          // Verify Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isVerifyingOtp ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: isVerifyingOtp
                  ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Verifying...",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
                  : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.verified_user, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Verify & Continue",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}