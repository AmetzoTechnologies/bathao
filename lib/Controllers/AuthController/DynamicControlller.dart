import 'package:get/get.dart';
import '../../Services/ApiService.dart';
import 'package:flutter/material.dart';

class Dynamiccontrolller extends GetxController {
  final ApiService api = ApiService();

  var languages = <Map<String, dynamic>>[].obs;
  var langSelected = <RxBool>[].obs;   // <-- SELECTION STATE
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    isLoading.value = true;

    final res = await api.getRequest("api/v1/public/get-languages");

    print("📡 API call finished. status: ${res.status}");

    if (res.isOk) {
      print("📦 raw response body: ${res.body}");

      languages.value = List<Map<String, dynamic>>.from(res.body);

      // Initialize selection list
      langSelected.value = List.generate(
        languages.length,
            (index) => false.obs,
      );

      print("✅ languages.length = ${languages.length}");
      print("👉 first item = ${languages.first}");
      print("👉 titles = ${languages.map((e) => e['title']).toList()}");
    } else {
      print("❌ Failed → ${res.body}");
    }

    isLoading.value = false;
  }

  /// Parse API color string into a real Flutter Color
  Color parseColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case "blue":
        return Colors.blue;
      case "lightblue":
        return Colors.lightBlue;
      case "black":
        return Colors.black;
      case "green":
        return Colors.green;
      case "orange":
        return Colors.orange;
      case "purple":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  /// Toggle selection in UI
  void toggleSelection(int index) {
    langSelected[index].value = !langSelected[index].value;
  }
}
