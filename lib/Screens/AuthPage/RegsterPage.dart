
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

import '../../Controllers/AuthController/RegisterController.dart';
import '../../Theme/Colors.dart';
import '../../Widgets/ProfileImagePicker.dart';
import 'LanguegeSelectionPage.dart';

class RegisterPage extends StatelessWidget {
  final String phone;
  final String countryCode;
  RegisterPage({super.key, required this.phone, required this.countryCode});
  RegisterController controller = Get.put(RegisterController());
  final _formKey = GlobalKey<FormState>();

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
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressBar(
                          maxSteps: 2,
                          progressType:
                              LinearProgressBar
                                  .progressTypeLinear, // Use Linear progress
                          currentStep: 1,
                          progressColor: AppColors.progressBarColor,
                          backgroundColor: AppColors.progressBarBackground,
                          borderRadius: BorderRadius.circular(10), //  NEW
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 33,
                          ),
                        ),
                        Text(
                          'Create your account to access personalized features,',
                        ),
                        SizedBox(height: 10),
                        Text("Name"),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            } else if (value.length < 3) {
                              return "Please enter at least 3 letter";
                            }
                            return null;
                          },
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            fillColor: AppColors.textInputColor,
                            filled: true,
                            hintText: 'Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.borderColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Date of Birth"),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose your DOB';
                            }
                            return null;
                          },
                          controller: controller.dobController,
                          readOnly: true, // User cannot type manually
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(
                                DateTime.now().year - 18,
                                DateTime.now().month,
                                DateTime.now().day,
                              ),
                            );

                            if (pickedDate != null) {
                              String formattedDate =
                                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                              controller.dobController.text = formattedDate;
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: AppColors.textInputColor,
                            filled: true,
                            hintText: "DD/MM/YYYY",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.borderColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text("Gender"),
                        DropdownButtonFormField<String>(
                          style: TextStyle(
                            color: AppColors.textColor,
                          ), // Selected text
                          iconEnabledColor: AppColors.textColor,
                          dropdownColor: AppColors.textInputColor,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.textInputColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: AppColors.borderColor,
                              ),
                            ),
                          ),
                          hint: Text(
                            // ✅ This sets the actual hint text and its color
                            "Select Gender",
                            style: TextStyle(color: AppColors.borderColor),
                          ),
                          value: null, // No initial value
                          items:
                              ["Male", "Female", "Other"]
                                  .map(
                                    (gender) => DropdownMenuItem(
                                      value: gender,
                                      child: Text(gender),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            controller.gender = value!;
                            print("Selected gender: $value");
                          },
                        ),
                        SizedBox(height: 10),
                        Text("Profile Photo"),
                        ProfileImagePicker(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Obx(
                    () =>
                        controller.isLoading.value
                            ? CircularProgressIndicator(
                              color: AppColors.progressBarColor,
                            )
                            : InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  // Form is valid
                                  // Proceed only if image is picked
                                  Get.to(
                                    LanguageSelectionPage(
                                      phoneNumber: phone,
                                      countryCode: countryCode,
                                      name: controller.nameController.text,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.getStartBackground,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Continue",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.textColor,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.textColor.withOpacity(
                                        0.8,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.textColor.withOpacity(
                                        0.6,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.textColor.withOpacity(
                                        0.4,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: AppColors.buttonGradient,
                                          begin: Alignment.topLeft,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.textColor
                                                .withValues(alpha: 0.30),
                                            blurRadius: 10,
                                            spreadRadius: 4,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
