import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/LanguageController/LanguageController.dart';

class LanguageChips extends StatelessWidget {
  final List<String> languages;
  final void Function(List<String>)? onSelectionChanged;

  LanguageChips({
    super.key,
    required this.languages,
    this.onSelectionChanged,
  });

  // ❌ DO NOT create a new controller here
  // final LanguageController controller = Get.put(LanguageController());

  // ✅ Correct: use existing controller
  LanguageController get controller => Get.find<LanguageController>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = screenWidth * 0.05;
    final verticalPadding = screenWidth * 0.025;
    final fontSize = screenWidth * 0.035;
    final chipSpacing = screenWidth * 0.03;

    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: languages.map((lang) {
            final isSelected = controller.isSelected(lang);

            return Padding(
              padding: EdgeInsets.only(right: chipSpacing),
              child: GestureDetector(
                onTap: () {
                  controller.toggleLanguage(lang);
                  if (onSelectionChanged != null) {
                    onSelectionChanged!(
                      controller.selectedLanguages,
                    );
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color:
                    isSelected ? AppColors.onBoardPrimary : AppColors.grayColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.transparent,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    lang,
                    style: TextStyle(
                      fontSize: fontSize,
                      color:
                      isSelected ? Colors.greenAccent : AppColors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
