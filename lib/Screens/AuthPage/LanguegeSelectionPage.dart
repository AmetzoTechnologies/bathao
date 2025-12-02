import 'package:bathao/Controllers/AuthController/DynamicControlller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../../Theme/Colors.dart';
import '../../Controllers/AuthController/RegisterController.dart';
import '../../Controllers/LanguageController/LanguageController.dart';

class LanguageSelectionPage extends StatelessWidget {
  final String phoneNumber;
  final String name;
  final String countryCode;

  LanguageSelectionPage({
    super.key,
    required this.phoneNumber,
    required this.name,
    required this.countryCode,
  });

  // CONTROLLERS
  final langController = Get.put(Dynamiccontrolller()); // <--- NEW
  final registerController = Get.find<RegisterController>(); // <--- EXISTING

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.onBoardPrimary, AppColors.onBoardSecondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // -----------------------
                // HEADER + PROGRESS
                // -----------------------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressBar(
                      maxSteps: 2,
                      currentStep: 2,
                      progressType: LinearProgressBar.progressTypeLinear,
                      progressColor: AppColors.progressBarColor,
                      backgroundColor: AppColors.progressBarBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    SizedBox(height: 15),

                    Text("Choose your language",
                        style: TextStyle(fontSize: 28, color: Colors.white)),

                    Text("Choose your language for a personalized experience.",
                        style: TextStyle(fontSize: 15, color: Colors.white70)),
                    SizedBox(height: 15),
                  ],
                ),

                // -----------------------
                // LANGUAGES LIST (API)
                // -----------------------
                Expanded(
                  child: Obx(() {
                    if (langController.isLoading.value) {
                      return Center(
                        child: CircularProgressIndicator(
                            color: AppColors.textColor),
                      );
                    }

                    return GridView.builder(
                      itemCount: langController.languages.length,
                      gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.25,
                      ),
                      itemBuilder: (context, index) {
                        final lang = langController.languages[index];

                        return Column(
                          children: [
                            Obx(() {
                              return InkWell(
                                onTap: () {
                                  langController.toggleSelection(index);

                                  final title = lang['title'];

                                  if (registerController.languages
                                      .contains(title.toString().toLowerCase())) {
                                    registerController.languages.remove(
                                        title.toString().toLowerCase());
                                  } else {
                                    registerController.languages.add(
                                        title.toString().toLowerCase());
                                  }

                                  print("REGISTER LANGUAGES → "
                                      "${registerController.languages}");
                                },
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: langController.parseColor(
                                        lang['bgColor']),
                                    border: langController.langSelected[index]
                                        .value
                                        ? Border.all(
                                      color: AppColors.textColor,
                                      width: 4,
                                    )
                                        : null,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    lang['icon'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            SizedBox(height: 6),
                            Text(
                              lang['title'],
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        );
                      },
                    );
                  }),
                ),

                // -----------------------
                // CONTINUE BUTTON
                // -----------------------
                InkWell(
                  onTap: () {
                    registerController.registerUser(
                        name, phoneNumber, countryCode);
                  },
                  child: Obx(() {
                    return Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.getStartBackground,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: registerController.isLoading.value
                          ? CircularProgressIndicator(
                          color: AppColors.progressBarColor)
                          : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Continue",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios,
                              color: AppColors.textColor),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
