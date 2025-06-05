import 'package:get/get.dart';

import '../controllers/video_calling_controller.dart';

class VideoCallingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoCallingController>(
      () => VideoCallingController(),
    );
  }
}
