import 'dart:ui';
import 'package:bathao/Screens/CallHistoryPage/CallHistoryPage.dart';
import 'package:bathao/Screens/CoinPurchasePage/CoinPurchasePage.dart';
import 'package:bathao/Screens/HomePage/HomePage.dart';
import 'package:bathao/Screens/ProfilePage/ProfilePage.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/BottomNavController/BottomNavController.dart';

class MainPage extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    HomePage(),
    CallHistoryPage(),
    CoinPurchasePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.scaffoldColor,
        extendBody: true,
        body: Stack(
          children: [
            pages[controller.selectedIndex.value],
            Positioned(
              left: 8,
              right: 8,
              bottom: 10,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blueAccent.withOpacity(0.1),
                          Colors.blueAccent.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _navItem(
                          icon: Icons.home_rounded,
                          label: "Home",
                          index: 0,
                          controller: controller,
                        ),
                        _navItem(
                          icon: Icons.phone_forwarded_rounded,
                          label: "Recents",
                          index: 1,
                          controller: controller,
                        ),
                        _navItem(
                          icon: Icons.account_balance_wallet_rounded,
                          label: "Wallet",
                          index: 2,
                          controller: controller,
                        ),
                        _navItem(
                          icon: Icons.person_rounded,
                          label: "Profile",
                          index: 3,
                          controller: controller,
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

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
    required BottomNavController controller,
  }) {
    bool isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              Color(0xFF000000),
              Color(0xFF0a192f),
              Color(0xFF112240),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Color(0xFF112240).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.grey.shade400,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}