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
  final langController = Get.put(Dynamiccontrolller());
  final registerController = Get.find<RegisterController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;
    final isMediumScreen = size.width >= 360 && size.width < 600;
    final isLargeScreen = size.width >= 600;

    // Responsive values
    final horizontalPadding = isSmallScreen ? 12.0 : (isMediumScreen ? 16.0 : 24.0);
    final titleFontSize = isSmallScreen ? 24.0 : (isMediumScreen ? 28.0 : 32.0);
    final subtitleFontSize = isSmallScreen ? 13.0 : (isMediumScreen ? 15.0 : 17.0);
    final crossAxisCount = isLargeScreen ? 3 : 2;
    final gridItemSize = isSmallScreen ? 100.0 : (isMediumScreen ? 120.0 : 140.0);
    final iconSize = isSmallScreen ? 24.0 : (isMediumScreen ? 28.0 : 32.0);
    final buttonFontSize = isSmallScreen ? 18.0 : (isMediumScreen ? 20.0 : 22.0);

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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            SizedBox(height: isSmallScreen ? 12 : 15),
                            Text(
                              "Choose your language",
                              style: TextStyle(
                                fontSize: titleFontSize,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Choose your language for a personalized experience.",
                              style: TextStyle(
                                fontSize: subtitleFontSize,
                                color: Colors.white70,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 15),
                          ],
                        ),

                        // -----------------------
                        // LANGUAGES GRID (API)
                        // -----------------------
                        Obx(() {
                          if (langController.isLoading.value) {
                            return SizedBox(
                              height: size.height * 0.5,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.textColor,
                                ),
                              ),
                            );
                          }

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: langController.languages.length,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: isSmallScreen ? 8 : 10,
                              mainAxisSpacing: isSmallScreen ? 8 : 10,
                              childAspectRatio: isSmallScreen ? 1.1 : 1.15,
                            ),
                            itemBuilder: (context, index) {
                              final lang = langController.languages[index];
                              return Obx(() {
                                final isSelected = langController.langSelected[index].value;
                                return InkWell(
                                  onTap: () {
                                    langController.toggleSelection(index);
                                    final title = lang['title'];
                                    if (registerController.languages
                                        .contains(title.toString().toLowerCase())) {
                                      registerController.languages
                                          .remove(title.toString().toLowerCase());
                                    } else {
                                      registerController.languages
                                          .add(title.toString().toLowerCase());
                                    }
                                    print("REGISTER LANGUAGES → ${registerController.languages}");
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: gridItemSize,
                                        width: gridItemSize,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: langController.parseColor(lang['bgColor']),
                                          border: isSelected
                                              ? Border.all(
                                            color: AppColors.textColor,
                                            width: isSmallScreen ? 3 : 4,
                                          )
                                              : null,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          lang['icon'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: iconSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        lang['title'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSmallScreen ? 12 : 14,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                          );
                        }),

                        SizedBox(height: 16),

                        // -----------------------
                        // CONTINUE BUTTON
                        // -----------------------
                        Center(
                          child: InkWell(
                            onTap: () {
                              registerController.registerUser(
                                name,
                                phoneNumber,
                                countryCode,
                              );
                            },
                            borderRadius: BorderRadius.circular(40),
                            child: Obx(() {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 24 : 32,
                                  vertical: isSmallScreen ? 12 : 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.getStartBackground,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: registerController.isLoading.value
                                    ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.progressBarColor,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Continue",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: buttonFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.textColor,
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}