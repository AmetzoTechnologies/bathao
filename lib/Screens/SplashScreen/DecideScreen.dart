import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:bathao/Widgets/MainPage/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/AuthController/AuthController.dart';
import '../../Controllers/CallController/CallController.dart';
import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/ListenerController/ListenerController.dart';
import '../../Controllers/PaymentController/PaymentController.dart';
import '../AuthPage/LoginPage.dart';
import '../HomePage/HomePage.dart';
import '../UpdateScreen/UpdateScreen.dart';

class DecideScreen extends StatelessWidget {
  DecideScreen({super.key});

  final AuthController controller = Get.put(AuthController());

  Future<Widget> checkAuth() async {
    if (jwsToken != null) {
      await controller.getUserData();
      bool isVersionOk = await controller.checkAppVersion();
      if (isVersionOk) {
        return const UpdateAppScreen();
      }
      return MainPage();
    } else {
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.onBoardSecondary,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Log error and fallback to login
          print('Error during checkAuth: ${snapshot.error}');
          return LoginPage();
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          // Fallback safety
          return LoginPage();
        }
      },
    );
  }
}
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PaymentController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(CallController(), permanent: true);
    Get.put(ListenerController(), permanent: true);
  }
}

