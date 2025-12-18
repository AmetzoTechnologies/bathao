import 'package:get/get.dart';

import '../CallController/CallController.dart';
import '../HomeController/HomeController.dart';
import '../ListenerController/ListenerController.dart';
import '../PaymentController/PaymentController.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ListenerController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(PaymentController(), permanent: true);
    Get.put(CallController(), permanent: true);
  }
}
