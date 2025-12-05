import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../Controllers/AuthController/AuthController.dart';
import '../../Controllers/CallController/CallController.dart';
import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/ListenerController/ListenerController.dart';
import '../../Controllers/PaymentController/PaymentController.dart';
import '../../Models/listners_model/receiver.dart' as ListenerModel;
import '../../Models/call_history_model/receiver.dart' as CallHistoryModel;
import '../../Services/ApiService.dart';
import '../../Services/CallApis/CallApis.dart';
import '../../Services/CallTracker.dart';
import '../../Theme/Colors.dart';
import 'Widget/LanguegeChipsWidget.dart';
import 'Widget/ListenerListWidget.dart';

class DummyHomePage extends StatelessWidget {
  DummyHomePage({super.key});

  final PaymentController controller = Get.put(PaymentController());
  final CallController callController = Get.put(
    CallController(),
    permanent: true,
  );
  final HomeController homeController = Get.put(HomeController());

  final ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    bool hasShownUnavailableDialog = false;
    final callTracker = CallTracker();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        // Load more when near bottom
        final listenerController = Get.find<ListenerController>();
        if (!listenerController.isLoading && listenerController.hasMore) {
          listenerController.fetchListeners();
        }
      }
    });

    // Your ZegoCloud initialization
    ZegoUIKitPrebuiltCallInvitationService().init(
      appSign: CallApis.appSign,
      appID: CallApis.appId,
      userID: userModel!.user!.id!, // Ensure userModel is not null here
      userName: userModel!.user!.name!,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        final config =
        data.invitees.length > 1
            ? (data.type == ZegoCallInvitationType.videoCall
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall())
            : (data.type == ZegoCallInvitationType.videoCall
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall());

        // earpiece
        config.avatarBuilder = (
            BuildContext context,
            Size size,
            ZegoUIKitUser? user,
            Map extraInfo,
            ) {
          if (user == null) {
            return const SizedBox();
          }
          final ListenerController listenerController =
          Get.find<ListenerController>();

          // 2. Search for the receiver in your list using the user.id
          String? avatarURL;
          String displayLetter = user.name.isNotEmpty ? user.name[0] : '?';

          try {
            final matchedReceiver = listenerController.listenerData
              .firstWhere((receiver) => receiver.id == user.id);
            // If a match is found, use its avatar URL
            if (matchedReceiver.profilePic != null) {
              avatarURL = "$baseImageUrl${matchedReceiver.profilePic}";
            }
          } catch (e) {
            print('Avatar not found for user ${user.id}, using default.');
          }
          return avatarURL != null
              ? Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(avatarURL),
                fit: BoxFit.cover,
              ),
            ),
          )
              : Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
            alignment: Alignment.center,
            child: Text(
              displayLetter,
              style: TextStyle(
                color: Colors.white,
                fontSize: size.width * 0.5,
                decoration: TextDecoration.none,
              ),
            ),
          );
        };
        return config;
      },

      events: ZegoUIKitPrebuiltCallEvents(
        room: ZegoCallRoomEvents(
          onStateChanged: callTracker.onRoomStateChanged,
        ),
        onCallEnd: callTracker.onCallEnd,
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallAccepted: (String callID, ZegoCallUser callee) async {
          debugPrint(
            "📲 Callee accepted invite. callID: $callID at ${DateTime.now()}",
          );
          // Potentially set controller.callId here if it's available and not set elsewhere
          callTracker.controller.callId =
              callID; // Assuming controller.callId is mutable
        },
        onError: (ZegoUIKitError error) {
          debugPrint(
            "❌ ZEGOCLOUD Error: ${error.code} - ${error.message} at ${DateTime.now()}",
          );

          // 107026 = all called users not registered
          if (error.code == 107026 && !hasShownUnavailableDialog) {
            hasShownUnavailableDialog = true;
            Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: AppColors.onBoardSecondary,
              title: "Error",
              middleText:
              "User is not online. Please call after some time.", // More specific message
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                hasShownUnavailableDialog = false;
                Get.back();
              },
            );
          } else if (error.code != 107026 && !hasShownUnavailableDialog) {
            // Handle other errors generally
            hasShownUnavailableDialog = true;
            Get.defaultDialog(
              barrierDismissible: false,
              backgroundColor: AppColors.onBoardSecondary,
              title: "Error",
              middleText:
              "An error occurred. Please try again later. Code: ${error.code}",
              textConfirm: "OK",
              confirmTextColor: Colors.white,
              onConfirm: () {
                hasShownUnavailableDialog = false;
                Get.back();
              },
            );
          }
          // If dialog is already shown, do nothing to avoid multiple dialogs
        },
        // add more invitation events as needed
      ),
    );
    controller.getCoin();

    return Scaffold(
      backgroundColor: Colors.black12,
      body: CustomScrollView(
        slivers: [
          Obx(() {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            final double expandedHeight = homeController.showSearchInAppBar.value
                ? screenHeight * 0.08
                : screenHeight * 0.22;

            return SliverAppBar(
              pinned: true,
              floating: false,
              stretch: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              expandedHeight: expandedHeight,
              collapsedHeight: screenHeight * 0.08,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final collapsedHeight = screenHeight * 0.08;
                  final scrollProgress = ((expandedHeight - constraints.maxHeight) /
                      (expandedHeight - collapsedHeight))
                      .clamp(0.0, 1.0);

                  final avatarSize = screenWidth * (0.14 - (0.06 * scrollProgress));
                  final coinIconSize = screenWidth * (0.06 - (0.02 * scrollProgress));
                  final coinTextSize = screenWidth * (0.045 - (0.01 * scrollProgress));

                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF000D64), Color(0xFF081DAA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                          vertical: screenHeight * 0.01,
                        ),
                        child: Stack(
                          children: [
                            // LEFT SIDE — PROFILE + NAME
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: avatarSize / 2,
                                    backgroundImage: NetworkImage(
                                      userModel!.user!.profilePic == null
                                          ? "https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?q=80"
                                          : "$baseImageUrl${userModel!.user!.profilePic}",
                                    ),
                                  ),
                                  if (scrollProgress < 0.3) ...[
                                    SizedBox(width: screenWidth * 0.04),
                                    Opacity(
                                      opacity: (1.0 - (scrollProgress / 0.3)).clamp(0.0, 1.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hello, ${userModel!.user!.name}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenWidth * 0.05,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "welcome Bathao",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: screenWidth * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // RIGHT SIDE — COINS
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (scrollProgress < 0.3) ...[
                                    Opacity(
                                      opacity: (1.0 - (scrollProgress / 0.3)).clamp(0.0, 1.0),
                                      child: Text(
                                        "Available Coins",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: screenWidth * 0.035,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.stars,
                                        color: Colors.amber,
                                        size: coinIconSize,
                                      ),
                                      SizedBox(width: screenWidth * 0.01),
                                      Obx(
                                            () => Text(
                                          totalCoin.value.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: coinTextSize,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Top Specialists",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                    LanguageChips(
                    languages: ['English', 'Malayalam', 'Kannada', 'Arabic', 'Tamil'],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          ListenerListWidget(scrollController: scrollController),
        ],
      ),
    );
  }
}
