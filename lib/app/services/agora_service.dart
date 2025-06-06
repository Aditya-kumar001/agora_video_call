
import 'dart:convert' show jsonDecode;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class AgoraService extends GetxService {
  static const String appId = "bb478c32cc534c26879fe27d9c10d3ea";
  static const String tempToken = "007eJxTYDj4tDLxXbeMtsDS4J5tVrbJV41nPT+S7/Y8LDdNzMG9SVeBISnJxNwi2dgoOdnU2CTZyMzC3DIt1cg8xTLZ0CDFODVxXrBTRkMgI8OZ3HhmRgYIBPG5GUpSi0ucMxLz8lJzGBgA/6shWw==";
  static const String channelName = 'testChannel';
  // Engine instance
  RtcEngine? _engine;
  bool _isInitialized = false;
  
  // Initialize the Agora engine
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      _engine = createAgoraRtcEngine();
      await _engine!.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));
      
      _isInitialized = true;
      print('Agora engine initialized successfully');
    } catch (e) {
      print('Error initializing Agora engine: $e');
      throw Exception('Failed to initialize Agora service: $e');
    }
  }
  
  // Get the RTC engine instance
  RtcEngine? get engine => _isInitialized ? _engine : null;

  Future<String> generateToken(String channelName) async {
    try {
      // Replace this URL with your actual token server endpoint
      final response = await http.get(
        Uri.parse('https://your-token-server.com/token?channelName=$channelName'),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'] as String;
      } else {
        print('Failed to get token: ${response.statusCode}');
        throw Exception('Failed to generate token');
      }
    } catch (e) {
      print('Error generating token: $e');
      
      // For testing purposes only - in production, always use a proper token
      // This is NOT secure and should NOT be used in production
      return tempToken;
    }
  }
  
  // Join a channel with the given parameters
  Future<void> joinChannel({
    required String token,
    required String channelName,
    required int uid,
    required bool isVideo,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      // Set channel options based on call type
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      
      // Enable video for video calls
      if (isVideo) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
      } else {
        await _engine!.disableVideo();
      }
      
      // Join the channel
      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ),
      );
      
      print('Successfully joined channel: $channelName');
    } catch (e) {
      print('Error joining channel: $e');
      throw Exception('Failed to join channel: $e');
    }
  }
  
  // Leave the current channel
  Future<void> leaveChannel() async {
    if (!_isInitialized || _engine == null) return;
    
    try {
      await _engine!.leaveChannel();
      print('Left channel successfully');
    } catch (e) {
      print('Error leaving channel: $e');
    }
  }
  
  // Dispose the engine when no longer needed
  void dispose() {
    if (_engine != null) {
      _engine!.release();
      _engine = null;
      _isInitialized = false;
    }
  }
}