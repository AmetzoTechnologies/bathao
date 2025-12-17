
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/user_model/user_model.dart';
import '../../Screens/AuthPage/LoginPage.dart';
import '../../Screens/AuthPage/OtpVerfyPage.dart';
import '../../Screens/AuthPage/RegsterPage.dart';
import '../../Services/ApiService.dart';
import '../../Theme/Colors.dart';
import '../../Widgets/MainPage/MainPage.dart';
import '../ListenerController/ListenerController.dart';
import 'RegisterController.dart';
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

          print("✅ Token saved: ${jwsToken?.substring(0, 20)}...");

          // Get user data first
          await getUserData();

          // Initialize Zego
          await initZegoCallService(
            userId: userModel!.user!.id!,
            userName: userModel!.user!.name!,
          );

// Initialize ListenerController
          if (!Get.isRegistered<ListenerController>()) {
            Get.put(ListenerController());
          } else {
            Get.find<ListenerController>().refreshListeners();
          }

          // Now navigate to MainPage with data already loaded
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
      print("❌ Error in verifyOTP: $e");
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