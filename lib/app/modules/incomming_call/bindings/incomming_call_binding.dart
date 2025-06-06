import 'package:get/get.dart';

import '../controllers/incomming_call_controller.dart';

class IncommingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IncommingCallController>(
      () => IncommingCallController(),
    );
  }
}
