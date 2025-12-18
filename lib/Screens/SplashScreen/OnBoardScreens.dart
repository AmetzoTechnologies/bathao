 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controllers/OnBoardController/OnBoardController.dart';
import '../AuthPage/LoginPage.dart';
import 'OnBoardScreenOne.dart';

class OnBoardScreens extends StatefulWidget {
  const OnBoardScreens({super.key});

  @override
  State<OnBoardScreens> createState() => _OnBoardScreensState();
}

class _OnBoardScreensState extends State<OnBoardScreens> {
  final PageController _controller = PageController();
  final OnBoardController _onBoardController = Get.put(OnBoardController());

  @override
  void initState() {
    super.initState();
    // Make status bar transparent for immersive experience
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: PageView(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) => _onBoardController.setCurrentPage(index),
        children: [
          /// PAGE 1
          Obx(
                () => OnBoardPage(
              imagePath: 'assets/onboarding_1.png',
              title: 'Where Voices Spark Connections',
              subtitle:
              'Discover meaningful relationships through real-time voice & video calls. No texts. Just talk. Real feelings start here.',
              currentPage: _onBoardController.currentPage.value,
              onTap: () => _handleNext(context),
            ),
          ),

          /// PAGE 2
          Obx(
                () => OnBoardPage(
              imagePath: 'assets/onboarding_2.png',
              title: 'Meet. Match. Call. Connect.',
              subtitle:
              'Experience real connections through voice and video. Let your voice lead the way to something special.',
              currentPage: _onBoardController.currentPage.value,
              onTap: () => _handleNext(context),
            ),
          ),

          /// PAGE
          Obx(
                () => OnBoardPage(
              imagePath: 'assets/onboarding_3.png',
              title: 'Where Voices Spark Real Connections',
              subtitle:
              'Find your match, make meaningful conversations, and fall in love through real-time voice and video calling.',
              currentPage: _onBoardController.currentPage.value,
              onTap: () => _completeOnboarding(context),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigate to next page
  void _handleNext(BuildContext context) {
    final currentPage = _onBoardController.currentPage.value;

    if (currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Complete onboarding and navigate to login
  Future<void> _completeOnboarding(BuildContext context) async {
    try {
      final pref = await SharedPreferences.getInstance();
      await pref.setBool('onboard_seen', true);

      // Add slight delay for better UX
      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        Get.off(
              () => LoginPage(),
          transition: Transition.fadeIn,
          duration: const Duration(milliseconds: 500),
        );
      }
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
      // Navigate anyway to prevent user from getting stuck
      if (mounted) {
        Get.off(() => LoginPage());
      }
    }
  }
}