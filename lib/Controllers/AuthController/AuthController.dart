import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Models/user_model.dart';
import 'package:bathao/Models/user_model/user_model.dart';
import 'package:bathao/Screens/AuthPage/LoginPage.dart';
import 'package:bathao/Screens/AuthPage/OtpVerfyPage.dart';
import 'package:bathao/Screens/AuthPage/RegsterPage.dart';
import 'package:bathao/Screens/HomePage/HomePage.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:bathao/Widgets/MainPage/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'call_init_service.dart';

UserDataModel? userModel;

class AuthController extends GetxController {
  var isAgreed = false.obs;
  var selectedCountryCode = '+91'.obs;
  final phoneController = TextEditingController();
  RxInt secondsRemaining = 30.obs;
  RxString otp = ''.obs;
  String? token;
  var isLoading = false.obs;
  String? updateUrl;

  final ApiService _apiService = ApiService();
  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  Future<bool> checkAppVersion() async {
    final endpoint = "api/v1/user/get-app-version";
    try {
      // Example API call
      final response = await _apiService.getRequest(
        endpoint,
      ); // Replace with actual call
      if (response.isOk) {
        print(response.body);
        final currentVersion = '1.0.1';
        updateUrl = response.body['link'];
        final version = response.body['version'];
        return currentVersion != version;
      } else {
        print(response.body);
        return false;
      }
    } catch (e) {
      print("Version check failed: $e");
      return false; // Fallback: assume OK to let user in
    }
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
        startTimer();
      }
    });
  }

  void resendCode() {
    secondsRemaining.value = 30;
    startTimer();
    sendOtp();
    // trigger resend OTP API here
  }

  Future verifyOTP() async {
    final data = {
      'countryCode': selectedCountryCode.value,
      'phone': phoneController.text,
      'otp': otp.value,
    };
    isLoading.value = true;
    try {
      final response = await _apiService.postRequest(
        'api/v1/user/verify-otp',
        data,
      );
      if (response.isOk) {
        print(response.body);
        if (response.body['userExists'] == true) {
          token = response.body['token'];
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("token", token!);
          jwsToken = token;
          await getUserData();
          await initZegoCallService(
            userId: userModel!.user!.id!,
            userName: userModel!.user!.name!,
          );
          Get.offAll(MainPage());
        } else {
          Get.to(
            RegisterPage(
              phone: phoneController.text,
              countryCode: selectedCountryCode.value,
            ),
          );
        }
      } else {
        if (response.body['message'] == 'OTP already used or not sent') {
          Get.snackbar(
            "Error",
            "OTP Expired",
            backgroundColor: AppColors.textColor,
          );
        }
        print(response.body);
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleAgreement(bool? value) {
    isAgreed.value = value ?? false;
  }

  void updateCountryCode(String code) {
    selectedCountryCode.value = code;
  }

  void sendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.length < 10) {
      Get.snackbar(
        "Error",
        "Please enter a valid phone number",
        backgroundColor: Colors.white,
      );
      return;
    }
    if (!isAgreed.value) {
      Get.snackbar("Error", "Please accept the Terms & Conditions");
      return;
    }
    await sendOtpToUser();
    // TODO: Add actual OTP logic here
  }

  Future sendOtpToUser() async {
    final data = {
      'phone': phoneController.text,
      'countryCode': selectedCountryCode.value,
    };
    isLoading.value = true;
    try {
      print(data);
      final response = await _apiService.postRequest(
        'api/v1/user/send-otp',
        data,
      );
      if (response.isOk) {
        print(response.body);
        Get.snackbar(
          "Success",
          "OTP sent to $selectedCountryCode ${phoneController.text}",
        );
        Get.to(OtpVerificationPage());
      } else {
        print(response.body);
        print(response.status);
        if (response.body['message'] ==
            'Too many OTP requests. Try again later.') {
          Get.snackbar(
            "Error",
            "Too many OTP  requested,Please try after some times",
          );
        } else {
          print(response.body);
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future getUserData() async {
    try {
      final response = await _apiService.getRequest(
        'api/v1/user/get',
        bearerToken: jwsToken,
      );
      print("Bearer $jwsToken");
      if (response.isOk) {
        userModel = UserDataModel.fromJson(response.body);
        print("success get user data");
      } else {
        print("user not found");
        print(response.body);
        if (response.body['message'] == 'Invalid token' ||
            response.body['message'] == 'User not found') {
          print("object");
          Get.offAll(LoginPage());
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
