import 'dart:async';
import 'package:bathao/Controllers/PaymentController/PaymentController.dart';
import 'package:flutter/cupertino.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:bathao/Controllers/CallController/CallController.dart';
import 'package:get/get.dart';

import '../main.dart';

class CallTracker {
  Timer? _minuteTimer;
  Timer? _preCutoffTimer;
  final CallController controller = Get.find();
  final PaymentController paymentController = Get.find();

  // A flag to ensure call start logic runs only once per call login
  bool _isCallActive = false;

  void onRoomStateChanged(ZegoUIKitRoomState state) async {
    // debugPrint(
    //   '📡 Room state changed: ${state.reason.name} at ${DateTime.now()}',
    // );
    final zego = ZegoUIKit.instance;
    try {
      zego.setAudioOutputToSpeaker(false);
      if (state.reason == ZegoRoomStateChangedReason.Logined) {
        if (!_isCallActive) {
          // Ensure call start logic runs only once
          // defined earlier
          _isCallActive = true;
          // debugPrint('✅ Call started - Initializing call data');

          // Ensure receiverId and callType are set before starting the call
          if (receiverId == null) {
            // debugPrint(
            //   "❌ Error: receiverId or callType is null when logging in.",
            // );
            // Optionally, handle this error (e.g., hang up, show dialog)
            ZegoUIKitPrebuiltCallController().hangUp(
              Get.context!, // Still using Get.context, see notes below
              showConfirmation: false,
            );
            _clearTimers();
            return;
          }

          await controller.startCall(receiverId!, controller.callType);
          debugPrint('✅ Call started - Call ID: ${controller.callId}');
          int? coinBalance = totalCoin.value;
          if (coinBalance < 100) {
            debugPrint(
              "⚠️ Low balance ($coinBalance). Ending call in 59 seconds.",
            );

            // Cancel any existing pre-cutoff timer before starting a new one
            _preCutoffTimer?.cancel();
            _preCutoffTimer = Timer(const Duration(seconds: 59), () {
              debugPrint(
                "⛔ Call auto-ended due to insufficient balance. Triggering hangUp.",
              );
              if (_isCallActive) {
                // Only end call if it's still considered active
                controller
                    .endCall(controller.callId!)
                    .then((_) {
                      debugPrint("Backend call end successful.");
                    })
                    .catchError((e) {
                      debugPrint("Error ending call on backend: $e");
                    });
                ZegoUIKitPrebuiltCallController().hangUp(
                  Get.context!, // Use context if needed
                  showConfirmation: false,
                );
              }
              _clearTimers(); // Clear timers after hang-up is triggered
              _isCallActive = false; // Reset active flag
            });
          }

          // Cancel any existing minute timer before starting a new one
          _minuteTimer?.cancel();
          // Start the per-minute coin check
          _minuteTimer = Timer.periodic(const Duration(minutes: 1), (
            timer,
          ) async {
            debugPrint('⏱ Minute tick ${timer.tick} at ${DateTime.now()}');

            // Ensure callId is not null before checking balance
            if (controller.callId == null) {
              debugPrint(
                "⚠️ Call ID is null during minute check. Ending timer.",
              );
              _clearTimers();
              return;
            }

            int? balance = await controller.checkBalance(
              controller.callId!,
            ); // 👈 Reduce 100 and get balance
            debugPrint('💰 Current coin balance: $balance');

            if (balance == null || balance < 100) {
              debugPrint(
                "⚠️ Low balance ($balance). Ending call in 59 seconds.",
              );

              // Cancel any existing pre-cutoff timer before starting a new one
              _preCutoffTimer?.cancel();
              _preCutoffTimer = Timer(const Duration(seconds: 59), () {
                debugPrint(
                  "⛔ Call auto-ended due to insufficient balance. Triggering hangUp.",
                );
                if (_isCallActive) {
                  // Only end call if it's still considered active
                  controller
                      .endCall(controller.callId!)
                      .then((_) {
                        debugPrint("Backend call end successful.");
                      })
                      .catchError((e) {
                        debugPrint("Error ending call on backend: $e");
                      });
                  ZegoUIKitPrebuiltCallController().hangUp(
                    Get.context!, // Use context if needed
                    showConfirmation: false,
                  );
                }
                _clearTimers(); // Clear timers after hang-up is triggered
                _isCallActive = false; // Reset active flag
              });
            }
          });
        }
      } else if (state.reason == ZegoRoomStateChangedReason.Logout ||
          state.reason == ZegoRoomStateChangedReason.KickOut) {
        debugPrint(
          '❌ Call ended by ZegoCloud - reason: ${state.reason.name} at ${DateTime.now()}',
        );
        _clearTimers();
        _isCallActive = false; // Reset active flag when call logs out
        // The onCallEnd callback should handle the backend `endCall` and `getCoin`
      }
    } catch (e, st) {
      debugPrint('❌ Error in onRoomStateChanged: $e\n$st');
      _clearTimers(); // Clear timers on error to prevent leaks
      _isCallActive = false;
    }
  }

  void onCallEnd(ZegoCallEndEvent event, void Function() defaultAction) async {
    debugPrint(
      "❌ Call ended — reason: ${event.reason.name} at ${DateTime.now()}",
    );
    _clearTimers();
    _isCallActive = false; // Reset active flag
    defaultAction(); // Perform Zego's default action (e.g., close call UI)

    try {
      // Only call backend endCall if a callId was established
      if (controller.callId != null) {
        debugPrint("Attempting to end call on backend: ${controller.callId}");
        await controller.endCall(controller.callId!);
        debugPrint("Backend call ended successfully.");
      } else {
        debugPrint("No callId found, skipping backend endCall.");
      }
      await paymentController.getCoin();
      debugPrint("Coins refreshed.");
    } catch (e, st) {
      debugPrint("❌ Error during onCallEnd backend operations: $e\n$st");
    }
  }

  void _clearTimers() {
    debugPrint('Clearing timers...');
    _minuteTimer?.cancel();
    _minuteTimer = null;
    _preCutoffTimer?.cancel();
    _preCutoffTimer = null;
    debugPrint(
      'Timers cleared. Minute timer null: ${_minuteTimer == null}, Pre-cutoff timer null: ${_preCutoffTimer == null}',
    );
  }
}
