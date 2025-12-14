import 'dart:async';
import 'dart:convert';
import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Models/plan_model/plan.dart';
import 'package:bathao/Models/plan_model/plan_model.dart';
import 'package:bathao/Models/recharge_model/history.dart';
import 'package:bathao/Models/recharge_model/recharge_model.dart';
import 'package:bathao/Screens/CoinPurchasePage/PaymentWebView.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

RxInt totalCoin = 0.obs;

class PaymentController extends GetxController {
  final isLoading = false.obs;
  RxString currentOrderId = ''.obs;

  PlanModel model = PlanModel();
  RxList<Plan> coinPlan = <Plan>[].obs;
  final ApiService _apiService = ApiService();
  Rx<DateTime?> paymentExpiry = Rx<DateTime?>(null);
  bool paymentSuccess = false;
  Timer? paymentTimer;
  String? paymentUrl;
  late RechargeModel rechargeModel = RechargeModel();
  RxList<RechargeHistory> history = <RechargeHistory>[].obs;
  int page = 1;
  bool isLastPage = false;
  ScrollController scrollController = ScrollController();
  bool isLoadingMore = false;

  Future getCoin() async {
    final endpoint = 'api/v1/coin/get-user-coin-balance';
    try {
      final response = await _apiService.getRequest(
        endpoint,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        print(response.body);
        totalCoin.value = response.body['coins'];
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
  Future<void> refreshBalance() async {
    await getCoin();
  }


  Future<bool> verifyPaymentStatus(String orderId) async {
    final String endpoint = "api/v1/coin/payment-status?orderId=$orderId";
    isLoading.value = true;
    try {
      print("verify order iid is $orderId");
      final response = await _apiService.getRequest(
        endpoint,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        print(response.body);
        if (response.body['txnStatus'] == 'SUCCESS') {
          return true;
        } else {
          print(response.body);
          false;
        }
      }
    } catch (e) {
      print(e);
      rethrow;
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<void> addCoinPurchase(String orderId) async {
    final endpoint = 'api/v1/coin/credit'; // change this to your actual API
    try {
      final response = await _apiService.postRequest(endpoint, {
        "order_id": orderId,
      }, bearerToken: jwsToken);

      if (response.isOk) {
        Get.snackbar("Success", "Coins added to your account 🎉");
        await getCoin(); // Refresh coin balance
      } else {
        Get.snackbar("Error", "Failed to add coins");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> getCoinPlans() async {
    final endpoint = 'api/v1/user/get-all-plans';

    try {
      isLoading.value = true;

      final response = await _apiService.getRequest(
        endpoint,
        bearerToken: jwsToken,
      );

      if (response.isOk) {
        model = PlanModel.fromJson(response.body);
        coinPlan.value = model.plans ?? [];
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCoinPlans() async {
    coinPlan.clear();
    await getCoinPlans();
  }



  Future createPayment(String planId, String? email) async {
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    isLoading.value = true;
    final endpoint = 'api/v1/coin/recharge';
    final data = {"planId": planId, "email": email};
    try {
      final response = await _apiService.postRequest(
        endpoint,
        data,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        print(response.body);
        if (response.body['paymentUrl'] != null) {
          paymentUrl = response.body['paymentUrl'];
          final orderId = response.body['orderId'];
          if (paymentUrl != null) {
            await Navigator.of(Get.context!).push<bool>(
              MaterialPageRoute(
                builder:
                    (context) => PaymentWebView(
                      paymentUrl: paymentUrl!,
                      orderId: orderId,
                      // Your existing method
                    ),
              ),
            );
            paymentSuccess = await verifyPaymentStatus(orderId);

            // 3. Handle result
          }
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
      isLoadingMore = false;
      await getRechargeHistory(isInitial: true);
      Get.back(); // dismiss the loading dialog
      if (paymentSuccess) {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 10),
                  Text(
                    "Congratulations!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Recharge Successful",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.back(); // Close the dialog
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
            ),
          ),
        );

        await getCoin();

        // Refresh coin balance or other post-payment logic
      } else {
        Get.snackbar(
          'Cancelled',
          'Payment was not completed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.textColor,
        );
      }
      paymentSuccess = false;
    }
  }

  Future<void> launchPaymentFlow({
    required String paymentUrl,
    required String orderId,
    required Future<bool> Function(String orderId) verifyPaymentStatus,
  }) async {
    try {
      final encodedUrl = Uri.encodeFull(paymentUrl);
      final uri = Uri.parse(paymentUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // ✅ After user completes or cancels, show dialog to verify
        Get.defaultDialog(
          backgroundColor: AppColors.onBoardSecondary,
          title: "Verify Payment",
          middleText: "Have you completed the payment?",
          textConfirm: "Yes",
          textCancel: "Cancel",
          onConfirm: () async {
            await getRechargeHistory();
            Get.back(); // close dialog
            final verified = await verifyPaymentStatus(orderId);
            if (verified) {
              Get.defaultDialog(
                title: "Success",
                middleText: "Coins added successfully 🎉",
                textConfirm: "OK",
                onConfirm: () async {
                  print("ssssssssjjjjjjjjjjssssssssssss");

                  Get.back();
                },
              );
            } else {
              Get.snackbar("Pending", "Payment is not yet confirmed.");
            }
          },
          onCancel: () {
            Get.snackbar("Cancelled", "Payment was cancelled.");
          },
        );
      } else {
        Get.snackbar("Error", "Unable to open payment link.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to start payment: $e");
    }
  }

  Future<void> getRechargeHistory({bool isInitial = false}) async {
    if (isLoadingMore || isLastPage) return;
    print('ssssssssssssssssssssssssssssssssssssssssssssssssssssssss');
    isLoadingMore = true;
    if (isInitial) {
      page = 1;
      history.clear();
    }

    final endpoint = "api/v1/coin/recharge-history?page=$page&limit=10";
    try {
      final response = await _apiService.getRequest(
        endpoint,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        print(response.body);
        rechargeModel = RechargeModel.fromJson(response.body);
        if (rechargeModel.history == null || rechargeModel.history!.isEmpty) {
          isLastPage = true;
        } else {
          history.addAll(rechargeModel.history!);
          page++;
        }
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    } finally {
      isLoadingMore = false;
    }
  }

  @override
  void onInit() async {
    super.onInit();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 100) {
        getRechargeHistory();
      }
    });

    await Future.wait([
      getCoinPlans(),
      getCoin(),
    ]);

    getRechargeHistory(isInitial: true);
  }


  @override
  void onClose() {
    paymentTimer?.cancel();
    super.onClose();
  }
}
