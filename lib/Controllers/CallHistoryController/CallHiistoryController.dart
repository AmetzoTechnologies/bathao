
import 'package:get/get.dart';
import '../../Models/call_history_model/call_history_model.dart';
import '../../Models/call_history_model/history.dart';
import '../../Services/ApiService.dart';
import '../AuthController/RegisterController.dart';

class CallHistoryController extends GetxController {
  CallHistoryModel callHistoryModel = CallHistoryModel();
  RxList<History> historyData = <History>[].obs;
  final ApiService _apiService = ApiService();
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  int currentPage = 1;
  final int limit = 10;

  Future<void> getHistory() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    final endpoint = 'api/v1/call/user-call-history?page=$currentPage&limit=$limit';

    try {
      final response = await _apiService.getRequest(
        endpoint,
        bearerToken: jwsToken,
      );

      if (response.isOk) {
        final fetched = CallHistoryModel.fromJson(response.body);
        final newItems = fetched.history ?? [];

        if (newItems.isEmpty) {
          hasMore.value = false;
        } else {
          historyData.addAll(newItems);

          if (newItems.length < limit) {
            hasMore.value = false;
          }

          currentPage++;
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> refreshHistory() async {
    // reset pagination
    currentPage = 1;
    hasMore.value = true;

    // clear old data
    historyData.clear();

    // load first page again
    await getHistory();
  }



  @override
  void onInit() {
    super.onInit();
    getHistory();
  }
}
