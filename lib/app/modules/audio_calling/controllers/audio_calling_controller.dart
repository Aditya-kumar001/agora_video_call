import 'package:get/get.dart';

class AudioCallingController extends GetxController {
  
  var userName =''.obs;
  var photoUrl = ''.obs;
  var channelName = ''.obs;
  var token = ''.obs;
  int uid = 0;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    token.value = args['token'];
    uid = args['uid'];
    userName.value = args['name'] ?? '';
    photoUrl.value = args['photo'] ?? '';
    channelName.value = args['channel'] ?? '';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
