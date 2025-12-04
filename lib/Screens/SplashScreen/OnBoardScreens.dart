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
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) => onBoardController.setCurrentPage(index),

        /// Your 3 onboarding pages (NO design change, only responsive)
        children: [
          Obx(
                () => OnBoardPage(
              imagePath: 'assets/onboarding_1.png',
              title: '"Where Voices Spark Connections"',
              subtitle:
              '"Discover meaningful relationships through real-time voice & video calls."\n"No texts. Just talk. Real feelings start here."',
              currentPage: onBoardController.currentPage.value,
              onTap: () => _handleNext(context),
            ),
          ),

          Obx(
                () => OnBoardPage(
              imagePath: 'assets/onboarding_2.png',
              title: 'Meet. Match. Call. Connect.',
              subtitle:
              'Experience real connections through voice and video. Let your voice lead the way to something special.',
              currentPage: onBoardController.currentPage.value,
              onTap: () => _handleNext(context),
            ),
          ),

          Obx(
                () => OnBoardPage(
              imagePath: 'assets/onboarding_3.png',
              title: 'Where Voices Spark Real Connections.',
              subtitle:
              'Find your match, make meaningful conversations, and fall in love through real-time voice and video calling.',
              currentPage: onBoardController.currentPage.value,
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setBool('onboard_seen', true);
                _handleNext(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Page navigation logic (unchanged)
  void _handleNext(BuildContext context) {
    int currentPage = onBoardController.currentPage.value;

    if (currentPage < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Get.off(LoginPage());
    }
  }
}
