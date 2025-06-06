import 'package:get/get.dart';
import '../services/agora_service.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register AgoraService as a permanent service
    Get.put<AgoraService>(AgoraService(), permanent: true);
  }
}