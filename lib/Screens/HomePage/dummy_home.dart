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
import '../../Services/ApiService.dart';
import '../../Services/CallApis/CallApis.dart';
import '../../Services/CallTracker.dart';
import '../../Theme/Colors.dart';
import 'Widget/LanguegeChipsWidget.dart';
import 'Widget/ListenerListWidget.dart';

class DummyHomePage extends StatelessWidget {
  DummyHomePage({super.key}) {
    _initZego();
  }

  final PaymentController controller = Get.put(PaymentController());
  final HomeController homeController = Get.put(HomeController());
  final CallController callController = Get.put(
    CallController(),
    permanent: true,
  );

  bool hasShownUnavailableDialog = false;
  final CallTracker callTracker = CallTracker();

  // -----------------------------------------------------------
  // 🔥 FIX: Call Init runs once in constructor
  // -----------------------------------------------------------
  void _initZego() {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appSign: CallApis.appSign,
      appID: CallApis.appId,
      userID: userModel!.user!.id!,
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

        config.avatarBuilder = (
            BuildContext context,
            Size size,
            ZegoUIKitUser? user,
            Map extraInfo,
            ) {
          if (user == null) return const SizedBox();

          try {
            final matchedReceiver = Get.find<ListenerController>()
                .listenerData
                .firstWhere((receiver) => receiver.id == user.id);

            if (matchedReceiver.profilePic != null) {
              return _buildAvatar(size, "$baseImageUrl${matchedReceiver.profilePic}");
            }
          } catch (_) {}

          return _buildLetter(size, user.name);
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
        onOutgoingCallAccepted: (String callID, ZegoCallUser callee) {
          callTracker.controller.callId = callID;
        },
        onError: _onZegoError,
      ),
    );

    controller.getCoin();
  }

  // -----------------------------------------------------------
  // 🧊 Avatar Builders
  // -----------------------------------------------------------
  Widget _buildAvatar(Size size, String url) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLetter(Size size, String name) {
    final letter = name.isNotEmpty ? name[0] : '?';
    return Container(
      width: size.width,
      height: size.height,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.5,
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // ❌ Error Handler
  // -----------------------------------------------------------
  void _onZegoError(ZegoUIKitError error) {
    debugPrint("❌ Zego Error: ${error.code} => ${error.message}");

    if (hasShownUnavailableDialog) return;

    hasShownUnavailableDialog = true;

    if (error.code == 107026) {
      Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppColors.onBoardSecondary,
        title: "Error",
        middleText: "User is not online. Please call after some time.",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
          hasShownUnavailableDialog = false;
          Get.back();
        },
      );
    } else {
      Get.defaultDialog(
        barrierDismissible: false,
        backgroundColor: AppColors.onBoardSecondary,
        title: "Error",
        middleText: "Error Occurred. Try Again. Code: ${error.code}",
        textConfirm: "OK",
        confirmTextColor: Colors.white,
        onConfirm: () {
          hasShownUnavailableDialog = false;
          Get.back();
        },
      );
    }
  }

  // -----------------------------------------------------------
  // 🏠 UI
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: CustomScrollView(
        controller: homeController.scrollController,
        slivers: [
          _buildSliverAppBar(context),
          _buildTopSection(),
          const ListenerListWidget(),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // 🧠 Sliver AppBar (unchanged)
  // -----------------------------------------------------------
  Widget _buildSliverAppBar(BuildContext context) {
    return Obx(() {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      final double expandedHeight = homeController.showSearchInAppBar.value
          ? screenHeight * 0.08
          : screenHeight * 0.22;

      return SliverAppBar(
        pinned: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        expandedHeight: expandedHeight,
        collapsedHeight: screenHeight * 0.08,
        flexibleSpace: LayoutBuilder(
          builder: (context, constraints) {
            final collapsedHeight = screenHeight * 0.08;
            final scrollProgress =
            ((expandedHeight - constraints.maxHeight) /
                (expandedHeight - collapsedHeight))
                .clamp(0.0, 1.0);

            final avatarSize =
                screenWidth * (0.14 - (0.06 * scrollProgress));
            final coinIconSize =
                screenWidth * (0.06 - (0.02 * scrollProgress));
            final coinTextSize =
                screenWidth * (0.045 - (0.01 * scrollProgress));

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
                child: _buildAppBarContent(
                  context,
                  avatarSize,
                  coinIconSize,
                  coinTextSize,
                  scrollProgress,
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildAppBarContent(
      BuildContext context,
      double avatarSize,
      double coinIconSize,
      double coinTextSize,
      double scrollProgress,
      ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.04,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Row(
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
                  SizedBox(width: 10),
                  Opacity(
                    opacity: (1 - (scrollProgress / 0.3)).clamp(0, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, ${userModel!.user!.name}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "welcome Bathao",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Row(
              children: [
                Icon(
                  Icons.stars,
                  color: Colors.amber,
                  size: coinIconSize,
                ),
                SizedBox(width: 6),
                Obx(() => Text(
                  totalCoin.value.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: coinTextSize,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // ⭐️ Top Section
  // -----------------------------------------------------------
  Widget _buildTopSection() {
    return SliverToBoxAdapter(
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
              languages: [
                'English',
                'Malayalam',
                'Kannada',
                'Arabic',
                'Tamil'
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
