 import 'package:get/get.dart';

import '../../Models/listners_model/listners_model.dart';
import '../../Models/listners_model/receiver.dart';
import '../../Services/ApiService.dart';
import '../AuthController/RegisterController.dart';

// Global reactive values
RxInt audioRate = 0.obs;
RxInt videoRate = 0.obs;

class ListenerController extends GetxController {
  final ApiService _apiService = ApiService();

  List<Receiver> listenerData = [];
  bool isLoading = false;
  bool hasMore = true;

  int page = 1;
  final int limit = 70;

  List<String> langs = [];
  String searchQuery = '';
  String sortOrder = '';

  @override
  void onInit() {
    super.onInit();
    // One single unified load
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await getCallRate();
    await fetchListeners(reset: true);
  }

  Future<void> getCallRate() async {
    try {
      final res = await _apiService.getRequest(
        "api/v1/user/get-user-cost",
        bearerToken: jwsToken,
      );
      if (res.isOk) {
        audioRate.value = res.body['audio'];
        videoRate.value = res.body['video'];
      } else {
        print("getCallRate error ${res.body}");
      }
    } catch (e) {
      print("getCallRate err: $e");
    }
  }

  Future<void> fetchListeners({bool reset = false}) async {
    if (isLoading) return;

    if (reset) {
      listenerData.clear();
      hasMore = true;
      page = 1;
    }

    if (!hasMore) return;

    isLoading = true;
    update();

    try {
      final res = await _apiService.getRequest(
        "api/v1/user/get-receivers"
            "?page=$page"
            "&limit=$limit"
            "&sortOrder=$sortOrder"
            "&search=$searchQuery"
            "&langs=${langs.join(',')}",
        bearerToken: jwsToken,
      );

      if (res.isOk) {
        ListenersModel model = ListenersModel.fromJson(res.body);

        final newItems = model.receivers ?? [];

        listenerData.addAll(newItems);

        if (newItems.length < limit) {
          hasMore = false;
        } else {
          page++;
        }
      } else {
        hasMore = false;
        print("fetchListeners error: ${res.body}");
      }
    } catch (e) {
      print("fetchListeners err: $e");
      hasMore = false;
    }

    isLoading = false;
    update();
  }

  Future<void> refreshListeners() async {
    await fetchListeners(reset: true);
  }

  void updateSearch(String value) {
    searchQuery = value;
    refreshListeners();
  }

  Future<void> updateSort(String sort) async {
    sortOrder = sort;
    refreshListeners();
  }

  void updateLangs(List<String> values) {
    langs = values;
    refreshListeners();
  }
}