import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../Services/CallApis/CallApis.dart';

Future<void> initZegoCallService({
  required String userId,
  required String userName,
}) async {
  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: CallApis.appId,
    appSign: CallApis.appSign,
    userID: userId,
    userName: userName,
    plugins: [ZegoUIKitSignalingPlugin()],
  );
}
