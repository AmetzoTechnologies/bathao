import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/ProfileController/ProfileController.dart';
import 'package:bathao/Screens/AuthPage/LoginPage.dart';
import 'package:bathao/Screens/StickerPickerPage/StickerPickerPage.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: Column(
        children: [
          // Header Section
          Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.onBoardPrimary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Stack(
                    children: [
                      Obx(() {
                        if (controller.pickedImage.value != null) {
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage: FileImage(
                              controller.pickedImage.value!,
                            ),
                          );
                        } else if (controller.profileImage.value.isNotEmpty) {
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              controller.profileImage.value,
                            ),
                          );
                        } else {
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              '$baseImageUrl${userModel!.user!.profilePic}',
                            ),
                          );
                        }
                      }),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap:
                              () => _showImageSourceDialog(context, controller),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Obx(
                            () => Text(
                              controller.name.value.isEmpty
                                  ? userModel!.user!.name!
                                  : controller.name.value,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white70,
                              size: 18,
                            ),
                            onPressed:
                                () => _showNameEditDialog(context, controller),
                          ),
                        ],
                      ),

                      Text(
                       controller.formatPhone(
                          userModel!.user!.countryCode ?? "",
                          userModel!.user!.phone ?? "",
                        ),
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      )
                      ,
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Info Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "App Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                _buildActionTile(
                  icon: Icons.privacy_tip,
                  label: "Privacy Policy",
                  onTap: () {
                    launchPrivacy();
                    // Navigate to Privacy Policy page
                  },
                ),
                _buildActionTile(
                  icon: Icons.support_agent,
                  label: "Get Support",
                  onTap: () {
                    launchSupport();
                    // Open email or support chat
                  },
                ),
                _buildActionTile(
                  icon: Icons.info_outline,
                  label: "About Us",
                  onTap: () {
                    launchAbout();
                    // Navigate to About page
                  },
                ),
                _buildActionTile(
                  icon: Icons.logout,
                  label: 'Logout',
                  onTap: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.remove('token');
                    Get.offAll(LoginPage());
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 10),

          // Logout button
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          //   child: ElevatedButton.icon(
          //     onPressed: () async {
          //       SharedPreferences pref = await SharedPreferences.getInstance();
          //       pref.remove('token');
          //       Get.offAll(LoginPage());
          //     },
          //     icon: const Icon(Icons.logout),
          //     label: const Text("Logout"),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: AppColors.onBoardPrimary,
          //       foregroundColor: Colors.white,
          //       minimumSize: const Size.fromHeight(50),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(16),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.onBoardSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.progressBarColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(

        padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical:15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF000000),
                Color(0xFF0a192f),
                Color(0xFF112240),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.progressBarColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> launchPrivacy() async {
    final Uri url = Uri.parse('https://bathaocalls.com/privacy_policy.html');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchAbout() async {
    final Uri url = Uri.parse('https://bathaocalls.com/#about');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchSupport() async {
    final Uri url = Uri.parse('https://bathaocalls.com/support');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> sendEmail() async {
    final Uri emailUri = Uri(scheme: 'mailto', path: 'bathaoapp@gmail.com');
    if (!await launchUrl(emailUri)) {
      throw 'Could not launch $emailUri';
    }
  }

  void _showImageSourceDialog(
    BuildContext context,
    ProfileController controller,
  ) {
    showModalBottomSheet(
      backgroundColor: AppColors.onBoardSecondary,

      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: AppColors.textColor),
                title: Text(
                  "Pick from Gallery",
                  style: TextStyle(color: AppColors.textColor),
                ),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.textColor),
                title: Text(
                  "Take a Photo",
                  style: TextStyle(color: AppColors.textColor),
                ),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle, color: AppColors.textColor),
                title: Text(
                  "Choose from Avatars",
                  style: TextStyle(color: AppColors.textColor),
                ),
                onTap: () async {
                  Get.back();
                  Get.to(() => StickerPickerPage());
                  // pass controller
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNameEditDialog(BuildContext context, ProfileController controller) {
    final TextEditingController nameController = TextEditingController();
    nameController.text =
        controller.name.value.isEmpty
            ? userModel!.user!.name!
            : controller.name.value;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            backgroundColor: AppColors.onBoardSecondary,
            title: Text("Edit Name"),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Enter your name"),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
              ElevatedButton(
                onPressed: () {
                  controller.setName(nameController.text);
                  Get.back();
                },
                child: Text("Save"),
              ),
            ],
          ),
    );
  }
}
