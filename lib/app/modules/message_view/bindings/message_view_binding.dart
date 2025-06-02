import 'package:get/get.dart';

import '../controllers/message_view_controller.dart';

class MessageViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageViewController>(
      () => MessageViewController(),
    );
  }
}
