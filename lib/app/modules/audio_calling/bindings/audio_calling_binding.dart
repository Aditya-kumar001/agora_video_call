import 'package:get/get.dart';

import '../controllers/audio_calling_controller.dart';

class AudioCallingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioCallingController>(
      () => AudioCallingController(),
    );
  }
}
