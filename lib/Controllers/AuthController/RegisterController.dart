import 'dart:convert';
import 'dart:io';

import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/ProfileController/ProfileController.dart';
import 'package:bathao/Models/user_model.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Widgets/MainPage/MainPage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;

String? jwsToken;

class RegisterController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  ProfileController profileController = Get.put(ProfileController());
  final ApiService _apiService = ApiService();
  late UserModel model = UserModel();
  AuthController controller = Get.put(AuthController());
  String gender = '';
  String phone = '';
  String dob = '';
  final ImagePicker _picker = ImagePicker();
  var pickedImage = Rxn<File>();
  List<String> languages = [];
  var isLoading = false.obs;
  final String defaultSticker = "assets/stickers/sticker1.png";
  RxString selectedSticker = "assets/stickers/man.png".obs;

  // Pick from gallery
  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  void pickImageFromGalleryOrCamera(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path);
      // clear sticker if image picked
    }
  }

  // Pick from camera
  Future<void> pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      pickedImage.value = File(image.path);
    }
  }

  Future registerUser(String name, String number, String countryCode) async {
    final endpoint = 'api/v1/user/register';

    // Check if profile image is picked
    if (pickedImage.value == null) {
      await assignStickerAsFile(selectedSticker.value);
    }
    final data = {
      "name": name,
      "gender": gender.toLowerCase(),
      "dateOfBirth":
          dobController
              .text, // Assuming you meant dateOfBirth, not gender twice
      "phone": number,
      'countryCode': countryCode,
      "profilePic": pickedImage.value,
      'langs': languages, // Important: This must be a File
    };
    isLoading.value = true;

    try {
      final response = await _apiService.postRequest(
        endpoint,
        data,
        isMultipart: true,
      );
      if (response.isOk) {
        model = UserModel.fromJson(response.body);
        final prefs = await SharedPreferences.getInstance();
        jwsToken = model.token;
        await prefs.setString('token', model.token!);
        print("Registered successfully");
        await controller.getUserData();

        Get.offAll(MainPage());
      } else {
        print("Failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("Exception in registerUser: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> assignStickerAsFile(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();

      // Unique filename based on time or sticker name
      final filename = 'sticker_${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File('${tempDir.path}/$filename');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      pickedImage.value = file;
      profileController.pickedImage.value = pickedImage.value;
      if (jwsToken != null) {
        print(pickedImage.value);
        await profileController.updateProfilePic(pickedImage.value);
      }
      selectedSticker.value = assetPath;
    } catch (e) {
      print("Error converting sticker to file: $e");
    }
  }
}
