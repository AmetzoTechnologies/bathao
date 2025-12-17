import 'dart:io';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../Controllers/AuthController/RegisterController.dart';
import '../Screens/StickerPickerPage/StickerPickerPage.dart';
import '../Theme/Colors.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.find();
    return Row(
      children: [
        Stack(
          children: [
            Obx(() {
              final File? imageFile = controller.pickedImage.value;
              final String sticker = controller.selectedSticker.value;

              return CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    imageFile != null
                        ? FileImage(imageFile)
                        : (sticker.isNotEmpty ? AssetImage(sticker) : null)
                            as ImageProvider?,
                child:
                    imageFile == null && sticker.isEmpty
                        ? const Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        )
                        : null,
              );
            }),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Get.to(() => const StickerPickerPage()),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.emoji_emotions,
                    size: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 24),
        GestureDetector(
          onTap: () => _showImageSourceSheet(context, controller),
          child: Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF7B2FF7), Color(0xFF9E52F7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  void _showImageSourceSheet(
    BuildContext context,
    RegisterController controller,
  ) {
    showModalBottomSheet(
      backgroundColor: AppColors.scaffoldColor,
      context: context,
      builder:
          (context) => Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo, color: AppColors.textColor),
                title: Text(
                  "Pick from Gallery",
                  style: TextStyle(color: AppColors.textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImageFromGalleryOrCamera(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera, color: AppColors.textColor),
                title: Text(
                  "Pick from Camera",
                  style: TextStyle(color: AppColors.textColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImageFromGalleryOrCamera(ImageSource.camera);
                },
              ),
              SizedBox(height: 10),
            ],
          ),
    );
  }
}
