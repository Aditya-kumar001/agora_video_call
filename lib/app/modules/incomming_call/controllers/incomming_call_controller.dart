import 'dart:async' show Timer;

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import '../../../routes/app_pages.dart';
// import '../../../services/agora_service.dart';

class IncommingCallController extends GetxController {
  // final AgoraService _agoraService = Get.find<AgoraService>();

  // Call data
  final RxString callerName = RxString(Get.arguments?['callerName'] ?? 'Unknown');
  final RxString callerPhotoUrl = RxString(Get.arguments?['callerPhotoUrl'] ?? '');
  final RxString channelName = RxString(Get.arguments?['channelName'] ?? '');
  final RxString token = RxString(Get.arguments?['token'] ?? '');
  final RxBool isVideoCall = RxBool(Get.arguments?['isVideo'] == 'true');

  // Call timeout (30 seconds)
  final int callTimeoutSeconds = 30;
  Timer? _callTimeoutTimer;
  Timer? _vibrationTimer;

  @override
  void onInit() {
    super.onInit();
    _startRinging();
    _startVibration();
    _startTimeout();
  }

  void _startRinging() {
    FlutterRingtonePlayer().playRingtone(looping: true, volume: 1.0, asAlarm: true);
  }

  void _stopRinging() {
    FlutterRingtonePlayer().stop();
  }

  void _startVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      _vibrationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        Vibration.vibrate(duration: 500);
      });
    }
  }

  void _stopVibration() {
    _vibrationTimer?.cancel();
    Vibration.cancel();
  }

  void _startTimeout() {
    _callTimeoutTimer = Timer(Duration(seconds: callTimeoutSeconds), () {
      declineCall(timeout: true);
    });
  }

  void _stopTimeout() {
    _callTimeoutTimer?.cancel();
  }

  void acceptCall() async {
    _stopRinging();
    _stopVibration();
    _stopTimeout();

    // Navigate to the call screen (audio or video)
    Get.offAllNamed(
      isVideoCall.value ? Routes.VIDEO_CALLING : Routes.AUDIO_CALLING,
      arguments: {
        'channelName': channelName.value,
        'token': token.value,
        'isVideo': isVideoCall.value,
        'userName': callerName.value,
        'photoUrl': callerPhotoUrl.value,
      },
    );
  }

  void declineCall({bool timeout = false}) {
    _stopRinging();
    _stopVibration();
    _stopTimeout();

    // Optionally, notify the server or caller that the call was declined or missed
    // TODO: Implement server notification if needed

    // Show a snackbar if timed out
    if (timeout) {
      Get.snackbar('Missed Call', 'You missed a call from ${callerName.value}');
    }

    // Close the incoming call screen
    Get.offAllNamed(Routes.HOME); // Or your main/home route
  }

  @override
  void onClose() {
    _stopRinging();
    _stopVibration();
    _stopTimeout();
    super.onClose();
  }
}