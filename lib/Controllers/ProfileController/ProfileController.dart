import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models/user_model/user_model.dart';
import '../../Services/ApiService.dart';
import '../AuthController/AuthController.dart';
import '../AuthController/RegisterController.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var profileImage = ''.obs; // avatar or uploaded path
  var pickedImage = Rx<File?>(null);
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  String formatPhone(String? cc, String? phone) {
    final c = cc ?? "";
    final p = phone ?? "";
    if (p.length <= 5) return "$c $p";
    return "$c ${p.substring(0, 5)} ${p.substring(5)}";
  }

  void setName(String newName) async {
    await updateProfileName(newName);
    name.value = newName;
  }

  void setAvatar(String imageUrl) {
    profileImage.value = imageUrl;
    pickedImage.value = null; // reset picked image if avatar selected
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      pickedImage.value = File(image.path);
      await updateProfilePic(pickedImage.value);
      profileImage.value = ''; // reset avatar if image picked
    }
  }

  Future updateProfileName(String name) async {
    final endpoint = "api/v1/user/update";
    final data = {"name": name};
    if (name == "") {
      return Get.snackbar("Error", "Please enter your name");
    }
    Get.dialog(Center(child: CircularProgressIndicator()));
    try {
      final response = await _apiService.putRequest(
        endpoint,
        data,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        print(response.body);
        userModel = UserDataModel.fromJson(response.body);
        Get.back();
        Get.back();
        Get.snackbar("Updated", "Profile name updated");
      } else {
        print(response.body);
        Get.snackbar("Something error", "Please try again later");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future updateProfilePic(File? profile) async {
    final endpoint = "api/v1/user/update";
    final data = {"profilePic": profile};
    if (profile!.path.isEmpty) {
      return Get.snackbar("Error", "No profile selected");
    }
    Get.dialog(Center(child: CircularProgressIndicator()));
    try {
      final response = await _apiService.putRequest(
        endpoint,
        data,
        bearerToken: jwsToken,
        isMultipart: true,
      );
      if (response.isOk) {
        print(response.body);
        userModel = UserDataModel.fromJson(response.body);
        Get.back();
        Get.back();
        Get.snackbar("Updated", "Profile pic updated");
      } else {
        print(response.body);
        Get.snackbar("Something error", "Please try again later");
      }
    } catch (e) {
      rethrow;
    }
  }
}
