 import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/AuthController/RegisterController.dart';
import '../../Theme/Colors.dart';

class StickerPickerPage extends StatelessWidget {
  const StickerPickerPage({super.key});

  final List<String> stickerAssets = const [
    "assets/stickers/man.png",
    "assets/stickers/man2.png",
    "assets/stickers/man3.png",
    "assets/stickers/man4.png",
    "assets/stickers/woman.png",
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onBoardPrimary, AppColors.onBoardSecondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose a Sticker",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: stickerAssets.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        await controller.assignStickerAsFile(
                          stickerAssets[index],
                        );
                        Get.back();
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(stickerAssets[index]),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
