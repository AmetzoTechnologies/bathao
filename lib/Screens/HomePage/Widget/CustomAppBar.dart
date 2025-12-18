
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Theme/Colors.dart';
import '../../CoinPurchasePage/CoinPurchasePage.dart';
import 'ProfileConnectPainter.dart';

class CustomHomeAppBar extends StatelessWidget {
  final String userName;
  final RxInt coinCount;
  final String profileImageUrl;

  const CustomHomeAppBar({
    super.key,
    required this.userName,
    required this.coinCount,
    required this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF000D64), Color(0xFF081DAA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.borderColor,
            offset: const Offset(0, 1),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              // 🔵 Background custom shape
              Positioned(
                left: 0,
                top: 20,
                bottom: 20,
                child: CustomPaint(
                  size: const Size(90, 170),
                  painter: ProfileConnectorPainter(),
                ),
              ),

              // 👤 Main content
              Stack(
                children: [
                  Row(
                    children: [
                      // 👤 Profile image
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(profileImageUrl),
                      ),
                      const SizedBox(width: 16),
                      // 👋 Greeting
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hello, $userName",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "wellcome Bathao",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 10,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(CoinPurchasePage());
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Available Coins",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Row(
                            children: [
                              const Text('🪙'),
                              const SizedBox(width: 4),
                              Obx(
                                () => Text(
                                  coinCount.value.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
