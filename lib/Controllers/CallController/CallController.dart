import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Controllers/PaymentController/PaymentController.dart';
import 'package:bathao/Services/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallController extends GetxController {
  final ApiService _apiService = ApiService();
  PaymentController controller = Get.put(PaymentController());
  String callType = "audio";
  String? callId;
  Future createCall(String externalUserId, bool voiceCall) async {
    final data = {
      "externalUserIds": [externalUserId],
      "headings": {"en": "Incoming Call"},
      "contents": {"en": "${userModel!.user!.name} is calling.."},
      "data": {
        "call": true,
        "caller_name": userModel!.user!.name!,
        'voiceCall': voiceCall,
      },
    };
    try {
      final response = await _apiService.postRequest(
        'api/v1/user/create-call',
        data,
      );
      if (response.isOk) {
        // print("call created");
      } else {
        // print(response.body);
      }
    } catch (e) {
      // print(e);/**/
      rethrow;
    }
  }

  Future startCall(String receiverId, String callType) async {
    final endpoint = 'api/v1/call/start-call';
    // print(receiverId);
    // print(callType);
    final data = {"receiverId": receiverId, "callType": callType};
    try {
      // print(
      //   "ssjasjdhdjkhghjhhhhhhhhhllllaaasssnnnnsnnwnwnnwnwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
      // );
      final response = await _apiService.postRequest(
        endpoint,
        data,
        bearerToken: jwsToken,
      );
      print(data);
      if (response.isOk) {
        // print("🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰🔰${response.body}");
        callId = response.body['callId'];
      } else {
        // print(response.body);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<int?> checkBalance(String callId) async {
    final endpoint = 'api/v1/call/check-call/$callId';
    try {
      final response = await _apiService.postRequest(
        endpoint,
        null,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        print(response.body);
        final data = response.body;
        return totalCoin.value = data['coinsRemaining'];
      } else {
        print(response.body);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future endCall(String callId) async {
    final endpoint = 'api/v1/call/end-call/$callId';
    try {
      final response = await _apiService.postRequest(
        endpoint,
        null,
        bearerToken: jwsToken,
      );
      if (response.isOk) {
        // print(response.body);
        // print("call ended");
      } else {
        // print(response.body);
      }
    } catch (e) {
      // print(e);
      rethrow;
    }
  }
}
