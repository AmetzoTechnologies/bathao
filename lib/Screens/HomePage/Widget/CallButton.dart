
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:get/get.dart';
import '../../../Controllers/CallController/CallController.dart';
import '../../../Controllers/PaymentController/PaymentController.dart';
import '../../../Theme/Colors.dart';
import '../../../main.dart';

class MyCustomCallButton extends StatelessWidget {
  final String userId;
  final String status;
  final String name;
  final bool isVideoCall;
  final bool isEnabled;

  MyCustomCallButton({
    super.key,
    required this.userId,
    required this.status,
    required this.name,
    this.isVideoCall = false,
    required this.isEnabled,
  });

  final PaymentController controller = Get.find();
  final CallController callController = Get.find();

  @override
  Widget build(BuildContext context) {
    // ❌ Disable button if isEnabled is false or user is offline
    final bool isButtonActive = isEnabled && status.toLowerCase() != "offline";

    return InkWell(
      onTap:
          isButtonActive
              ? () {
                print(totalCoin.value);
                receiverId = userId;

                if (totalCoin.value >= 100) {
                  if (status == "online") {
                    if (isVideoCall) {
                      if (totalCoin.value >= 200) {
                        callController.callType = "video";
                        ZegoUIKitPrebuiltCallInvitationService().send(
                          isVideoCall: true,
                          invitees: [ZegoCallUser(userId, name)],
                          resourceID: "zego_call",
                        );
                      } else {
                        Get.snackbar(
                          "Insufficient balance",
                          "You need at least 200 coins for a video call",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.textColor,
                        );
                      }
                    } else {
                      callController.callType = "audio";
                      ZegoUIKitPrebuiltCallInvitationService().send(
                        isVideoCall: false,
                        invitees: [ZegoCallUser(userId, name)],
                        resourceID: "zego_call",
                      );
                    }
                  } else if (status == "busy") {
                    Get.snackbar(
                      "User Busy",
                      "The user is currently on another call",
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.snackbar(
                      "Offline",
                      "Recipient is not available right now.",
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                } else {
                  Get.snackbar(
                    "Insufficient balance",
                    "Please recharge your coin balance",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.textColor,
                  );
                }
              }
              : null, // Disable tap if not active
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isButtonActive ? AppColors.onBoardPrimary : Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isVideoCall ? Icons.videocam_rounded : Icons.call,
          color: Colors.white,
        ),
      ),
    );
  }
}
