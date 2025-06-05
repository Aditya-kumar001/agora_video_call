// services/agora_service.dart

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class AgoraService {
  static const String appId = "bb478c32cc534c26879fe27d9c10d3ea";
  static const String tempToken = "007eJxTYPAztb86ccUWM1aXcx/Ln7XufmC4LTq+9HX9+73H3/gvNYxRYEhKMjG3SDY2Sk42NTZJNjKzMLdMSzUyT7FMNjRIMU5N7GdwzGgIZGRoudHIwsgAgSA+N0NJanGJc0ZiXl5qDgMDANlOJBs=";
  static const String channelName = 'testChannel';

  Future<void> initializeAgora(RtcEngine engine) async {
    await engine.initialize(RtcEngineContext(appId: appId));
    await engine.enableVideo();
  }

  Future<void> joinChannel(RtcEngine engine, String channelName, int uid, {String token = ''}) async {
    await engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel(RtcEngine engine) async {
    await engine.leaveChannel();
  }
}
