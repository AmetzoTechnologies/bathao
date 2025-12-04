import 'package:bathao/Screens/AuthPage/LoginPage.dart';
import 'package:bathao/Screens/SplashScreen/OnBoardScreenOne.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/OnBoardController/OnBoardController.dart';

class OnBoardScreens extends StatelessWidget {
  OnBoardScreens({super.key});
  final PageController controller = PageController();
  final OnBoardController onBoardController = Get.put(OnBoardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          onBoardController.setCurrentPage(index);
        },
        controller: controller,
        children: [
          Obx(
            () => OnBoardPage(
              imagePath: 'assets/onboarding_1.png', // Add your local image
              title: '"Where Voices Spark Connections"',
              subtitle:
                  '"Discover meaningful relationships through real-time voice & video calls.""No texts. Just talk. Real feelings start here."',
              isFirst: true,
              currentPage: onBoardController.currentPage.value,
              onTap: () {
                _handleNext(context);
              },
            ),
          ),
          Obx(
            () => OnBoardPage(
              imagePath: 'assets/onboarding_2.png',
              title: 'Meet. Match. Call. Connect.',
              subtitle:
                  'Experience real connections through voice and video. Let your voice lead the way to something special.',
              isFirst: false,
              currentPage: onBoardController.currentPage.value,
              onTap: () {
                _handleNext(context);
              },
            ),
          ),
          Obx(
            () => OnBoardPage(
              imagePath: 'assets/onboarding_3.png',
              title: 'Where Voices Spark Real Connections.',
              subtitle:
                  'Find your match, make meaningful conversations, and fall in love through real-time voice and video calling.',
              isFirst: false,
              currentPage: onBoardController.currentPage.value,
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setBool('onboard_seen', true);
                _handleNext(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleNext(BuildContext context) {
    int page = onBoardController.currentPage.value;

    if (page < 2) {
      controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // 👇 Do your custom function here (like navigate to login)
      Get.off(LoginPage()); // or any route you use
    }
  }
}
