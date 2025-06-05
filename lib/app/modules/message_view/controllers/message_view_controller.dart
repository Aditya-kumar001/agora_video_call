import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_task/app/services/agora_service.dart';

import '../../../routes/app_pages.dart';

class MessageViewController extends GetxController {
  final count = 0.obs;
  late final RtcEngine _engine;

  var userName =''.obs;
  var photoUrl = ''.obs;
  var channelName = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    userName.value = args['name'] ?? '';
    photoUrl.value = args['photoUrl'] ?? '';
    channelName.value = args['uid'] ?? '';
    _initAgora();
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(appId: AgoraService.appId),
    );
  }

  Future<void> joinCall({
    required String token,
    required String channelName,
    required bool isVideo,
    int uid = 0,
  }) async {
    await [Permission.microphone,if (isVideo) Permission.camera].request();

    if (isVideo) {
      await _engine.enableVideo();
      await _engine.startPreview();
    } else {
      await _engine.disableVideo();
    }

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );

    !isVideo ? 
    Get.toNamed(Routes.AUDIO_CALLING, arguments: {
      'token': token, 
      'uid' : uid,'photo' : photoUrl.value, 
      'name' : userName.value,
      'channel' : channelName
      })
    : Get.toNamed(Routes.VIDEO_CALLING, arguments: {token, uid,photoUrl.value, userName.value,channelName});
  }
}