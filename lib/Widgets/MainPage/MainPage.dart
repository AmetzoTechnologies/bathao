import 'package:bathao/Screens/CallHistoryPage/CallHistoryPage.dart';
import 'package:bathao/Screens/CoinPurchasePage/CoinPurchasePage.dart';
import 'package:bathao/Screens/HomePage/HomePage.dart';
import 'package:bathao/Screens/ProfilePage/ProfilePage.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/BottomNavController/BottomNavController.dart';
import '../../Screens/HomePage/dummy_home.dart';

class MainPage extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  final List<Widget> pages = [
    DummyHomePage() ,
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
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.onBoardSecondary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navItem(
                      icon: Icons.home,
                      label: "Home",
                      index: 0,
                      controller: controller,
                      activeGradient: const LinearGradient(
                        colors: [Color(0xFFDA00FF), Color(0xFF00FFD1)],
                      ),
                    ),
                    _navItem(
                      icon: Icons.call,
                      label: "Calls",
                      index: 1,
                      controller: controller,
                    ),
                    _navItem(
                      icon: Icons.monetization_on,
                      label: "Wallet",
                      index: 2,
                      controller: controller,
                    ),
                    _navItem(
                      icon: Icons.person,
                      label: "Profile",
                      index: 3,
                      controller: controller,
                    ),
                  ],
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
    Gradient? activeGradient,
  }) {
    bool isSelected = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShaderMask(
            shaderCallback: (bounds) {
              return isSelected && activeGradient != null
                  ? activeGradient.createShader(bounds)
                  : const LinearGradient(
                    colors: [Colors.grey, Colors.grey],
                  ).createShader(bounds);
            },
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
