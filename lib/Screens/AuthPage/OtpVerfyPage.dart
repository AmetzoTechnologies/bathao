 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../Controllers/AuthController/AuthController.dart';
import '../../Theme/Colors.dart';

class OtpVerificationPage extends GetView<AuthController> {
  const OtpVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E005A), Color(0xFF420029)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            const SizedBox(height: 20),

            // Title
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Otp ",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "Verification",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              "We’ve sent an SMS with an activation code to your WhatsApp",
              style: TextStyle(color: Colors.white70),
            ),
            Text(
              "${controller.selectedCountryCode} ${controller.phoneController.text}",
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Countdown Timer
            Obx(
                  () => Row(
                children: [
                  const Text(
                    "Send code again ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "00:${controller.secondsRemaining.value.toString().padLeft(2, '0')}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // OTP Field
            PinCodeTextField(
              keyboardType: TextInputType.number,
              length: 6,
              appContext: context,
              onChanged: (value) => controller.otp.value = value,
              pinTheme: PinTheme(
                errorBorderColor: AppColors.onBoardSecondary,
                activeFillColor: Colors.black,
                selectedFillColor: Colors.black,
                inactiveFillColor: Colors.black,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 50,
              ),
              textStyle: const TextStyle(color: Colors.white, fontSize: 20),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
            ),

            const SizedBox(height: 10),

            // Resend Text with Dynamic Style and Tap Control
            Center(
              child: Obx(() {
                final isClickable = controller.secondsRemaining.value == 0;
                return GestureDetector(
                  onTap: isClickable ? controller.resendCode : null,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "I didn’t receive a code ",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextSpan(
                          text: "Resend",
                          style: TextStyle(
                            color: isClickable ? Colors.red : Colors.white30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            const Spacer(),

            // Verify Button
            Obx(
                  () =>
              controller.isLoading.value
                  ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.textColor,
                ),
              )
                  : GestureDetector(
                onTap: controller.verifyOTP,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.getStartBackground,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Get Started",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textColor,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textColor.withOpacity(0.8),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textColor.withOpacity(0.6),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.textColor.withOpacity(0.4),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: AppColors.buttonGradient,
                              begin: Alignment.topLeft,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textColor.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 10,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}