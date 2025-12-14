import 'dart:ui';

import 'package:bathao/Screens/AuthPage/OtpVerfyPage.dart';
import 'package:bathao/Widgets/TermsCheckBox.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/AuthController/AuthController.dart';
import '../../Theme/Colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.loginPageGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Image.asset('assets/login_img.png'),
                  Container(
                    height: 400,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 0.47, // 47% as per Figma
                        colors: [
                          Color(0xFF081666).withOpacity(
                            0.6,
                          ), // or AppColors.loginGradient[0].withOpacity(0.6)
                          Colors.black.withOpacity(0.4),
                        ],
                        // AppColors.loginGradient,
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              CountryCodePicker(
                                onChanged:
                                    (country) => controller.updateCountryCode(
                                      country.dialCode ?? '+91',
                                    ),
                                initialSelection: 'IN',
                                backgroundColor: AppColors.onBoardPrimary,
                                showCountryOnly: false,
                                showOnlyCountryWhenClosed: false,
                                dialogBackgroundColor:
                                    AppColors.onBoardSecondary,
                                alignLeft: false,
                                padding: EdgeInsets.zero,
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                flagWidth: 28,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: controller.phoneController,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 10,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: 'XXX XXX XXXX',
                                    hintStyle: TextStyle(color: Colors.white70),
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'We will send a verification OTP to your mobile number entered below',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textColor,
                          ),
                        ),

                        TermsCheckbox(
                          isChecked: controller.isAgreed,
                          onTapTerms: () async {
                            await openWebsite();
                          },
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            if (controller.phoneController.text != '') {
                              controller.sendOtp();
                            } else {
                              Get.snackbar(
                                "Error",
                                "Please enter your number",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppColors.textColor,
                              );
                            }
                          },
                          child: Center(
                            child: Container(
                              width: 420,
                              padding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.getStartBackground,
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                      color: AppColors.textColor,
                                      fontSize: 22,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textColor,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textColor.withOpacity(
                                          0.8,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textColor.withOpacity(
                                          0.6,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.textColor.withOpacity(
                                          0.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Obx(
                                    () =>
                                        controller.isLoading.value
                                            ? CircularProgressIndicator(
                                              color: AppColors.progressBarColor,
                                            )
                                            : Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  colors:
                                                      AppColors.buttonGradient,
                                                  begin: Alignment.topLeft,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors.textColor
                                                        .withOpacity(0.3),
                                                    blurRadius: 10,
                                                    spreadRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                              ),
                                            ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openWebsite() async {
    final Uri url = Uri.parse(
      'https://bathaocalls.com/terms_and_conditions.html',
    );
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
