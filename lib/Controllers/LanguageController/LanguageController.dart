import 'package:get/get.dart';
import '../../Services/ApiService.dart';
import '../ListenerController/ListenerController.dart';

class LanguageController extends GetxController {
  final ApiService _apiService = ApiService();

  /// AVAILABLE LANGUAGES FROM API
  final RxList<String> availableLanguages = <String>[].obs;

  /// SELECTED LANGUAGES FOR FILTER
  final RxList<String> selectedLanguages = <String>[].obs;

  final ListenerController listenerController = Get.put(ListenerController());

  @override
  void onInit() {
    super.onInit();
    fetchLanguages();    // NEW: load the languages
  }

  /// FETCH LANGUAGES FROM API
  Future<void> fetchLanguages() async {
    try {
      final res = await _apiService.getRequest(
        "api/v1/public/get-languages",
      );

      if (res.isOk && res.body is List) {
        availableLanguages.value =
            (res.body as List).map((e) => e["title"].toString()).toList();
      } else {
        print("Language fetch failed: ${res.body}");
      }
    } catch (e) {
      print("Error fetching languages: $e");
    }
  }

  /// TOGGLE SELECTION
  void toggleLanguage(String lang) {
    if (selectedLanguages.contains(lang)) {
      selectedLanguages.remove(lang);
      listenerController.langs.remove(lang);
    } else {
      selectedLanguages.add(lang);
      listenerController.langs.add(lang);
    }

    listenerController.refreshListeners();
  }

  bool isSelected(String lang) => selectedLanguages.contains(lang);
}
