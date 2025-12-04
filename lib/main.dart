import 'package:bathao/Controllers/AuthController/AuthController.dart';
import 'package:bathao/Controllers/AuthController/RegisterController.dart';
import 'package:bathao/Screens/SplashScreen/DecideScreen.dart';
import 'package:bathao/Screens/SplashScreen/OnBoardScreens.dart';
import 'package:bathao/Theme/Colors.dart';
import 'package:bathao/Widgets/MainPage/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:screen_secure/screen_secure.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'Controllers/LanguageController/LanguageController.dart';
import 'Screens/AuthPage/LoginPage.dart';

final navigatorKey = GlobalKey<NavigatorState>();
String? receiverId;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenSecure.init(screenshotBlock: true, screenRecordBlock: true);
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnBoard = prefs.getBool('onboard_seen') ?? false;
  final token = prefs.getString('token');
  jwsToken = token;
  print(token);
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((val) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
      ZegoUIKitSignalingPlugin(),
    ]);
  });

  runApp(
    MyApp(
      hasSeenOnBoard: hasSeenOnBoard,
      hasToken: token != null && token.isNotEmpty,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnBoard;
  final bool hasToken;

  MyApp({
    super.key,
    required this.hasSeenOnBoard,
    required this.hasToken,
  });



  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: AppColors.textColor,
        ),
        useMaterial3: true,
      ),
        initialBinding:AppBinding(),
      home: _getInitialPage(),
    );
  }

  Widget _getInitialPage() {
    if (!hasSeenOnBoard) {
      return OnBoardScreens();
    } else if (!hasToken) {
      return LoginPage(); // replace with your actual login page
    } else {
      return DecideScreen(); // your actual home page
    }
  }
}
