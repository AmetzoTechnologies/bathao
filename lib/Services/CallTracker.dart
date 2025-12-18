import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:get/get.dart';

import '../Controllers/CallController/CallController.dart';
import '../Controllers/PaymentController/PaymentController.dart';
import '../main.dart';

class CallTracker {
Timer? _speakerTimer;
bool _isCallActive = false;

final CallController controller = Get.find();
final PaymentController paymentController = Get.find();

void onRoomStateChanged(ZegoUIKitRoomState state) async {
  if (state.reason == ZegoRoomStateChangedReason.Logined) {
    if (_isCallActive) return;
    _isCallActive = true;

    if (receiverId == null) {
      ZegoUIKitPrebuiltCallController().hangUp(
        Get.context!,
        showConfirmation: false,
      );
      return;
    }

    await controller.startCall(receiverId!, controller.callType);

    _enableSpeakerForAudioAndVideo();
  }

  if (state.reason == ZegoRoomStateChangedReason.Logout ||
      state.reason == ZegoRoomStateChangedReason.KickOut) {
    _clear();
  }
}

void _enableSpeakerForAudioAndVideo() {
  _speakerTimer?.cancel();

  _speakerTimer = Timer.periodic(
    const Duration(milliseconds: 200),
        (timer) {
      if (ZegoUIKitPrebuiltCallInvitationService().isInCall) {
        // 🔊 FORCE speaker for BOTH audio & video
        ZegoUIKit.instance.setAudioOutputToSpeaker(true);

        // safety re-apply (important for video)
        Future.delayed(const Duration(milliseconds: 300), () {
          ZegoUIKit.instance.setAudioOutputToSpeaker(true);
        });

        timer.cancel();
      }
    },
  );
}

void onCallEnd(ZegoCallEndEvent event, void Function() defaultAction) async {
  _clear();
  defaultAction();

  if (controller.callId != null) {
    await controller.endCall(controller.callId!);
  }

  await paymentController.getCoin();
}

void _clear() {
  _speakerTimer?.cancel();
  _speakerTimer = null;
  _isCallActive = false;
}
}
