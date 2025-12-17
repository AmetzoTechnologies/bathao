
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/AuthController/DynamicControlller.dart';
import '../../Controllers/LanguageController/LanguageController.dart';


class CheckLang extends StatelessWidget {
  const CheckLang({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Dynamiccontrolller()); // <-- IMPORTANT

    return Scaffold(
      appBar: AppBar(title: Text("Check Language API")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        // TEMP LOG VIEW
        return ListView.builder(
          itemCount: controller.languages.length,
          itemBuilder: (context, index) {
            final lang = controller.languages[index];
            return ListTile(
              title: Text(lang['title']),
              subtitle: Text(lang['icon']),
              trailing: Text(lang['bgColor']),
            );
          },
        );
      }),
    );
  }
}
