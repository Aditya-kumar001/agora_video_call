import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';

import '../../../services/agora_service.dart';

class AudioCallingController extends GetxController {
  
  final AgoraService _agoraService = Get.find<AgoraService>();
  
  // Call parameters
  final String channelName = Get.arguments?['channelName'] ?? AgoraService.channelName;
  final String token = Get.arguments?['token'] ?? AgoraService.tempToken;
  
  // Fixed: Create RxBool properly
  final RxBool isVideo = RxBool(Get.arguments?['isVideo'] ?? false);
  
  // User information
  final RxString remoteUserName = RxString(Get.arguments?['userName'] ?? 'User');
  final RxString remoteUserPhoto = RxString(Get.arguments?['photoUrl'] ?? '');
  
  // Call state
  final RxBool isLoading = RxBool(true);
  final RxInt remoteUid = RxInt(0);
  final RxBool isMuted = RxBool(false);
  final RxBool isSpeakerOn = RxBool(true);
  final RxString callDuration = RxString('00:00');
  final RxString callStatus = RxString('Connecting...');
  
  // Timer for call duration
  Timer? _callTimer;
  int _secondsElapsed = 0;
  
  // Get the Agora engine
  RtcEngine? get engine => _agoraService.engine;
  
  @override
  void onInit() {
    super.onInit();
    _initializeCall();
  }
  
  Future<void> _initializeCall() async {
    try {
      isLoading.value = true;
      
      // Initialize Agora service if not already initialized
      if (engine == null) {
        await _agoraService.initialize();
      }
      
      // Set up event handlers
      _setupEventHandlers();
      
      // Join the channel
      await _agoraService.joinChannel(
        token: token,
        channelName: channelName,
        uid: 0, // 0 means let the server assign a uid
        isVideo: isVideo.value,
      );
      
      // Start the call timer
      _startCallTimer();
      
      // Set speaker on by default for video calls
      if (isVideo.value) {
        await engine?.setEnableSpeakerphone(true);
        isSpeakerOn.value = true;
      }
      
      isLoading.value = false;
      callStatus.value = 'Calling...';
    } catch (e) {
      print('Error initializing call: $e');
      Get.snackbar('Error', 'Failed to initialize call: $e');
      isLoading.value = false;
      callStatus.value = 'Call failed';
    }
  }
  
  void _setupEventHandlers() {
    engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('Local user joined: ${connection.channelId}');
          callStatus.value = 'Connected';
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          print('Remote user joined: $uid');
          remoteUid.value = uid;
          callStatus.value = 'In call';
        },
        onUserOffline: (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          print('Remote user left: $uid, reason: $reason');
          remoteUid.value = 0;
          callStatus.value = 'User left';
          // Auto end call after a delay when remote user leaves
          Future.delayed(const Duration(seconds: 2), () {
            if (remoteUid.value == 0) {
              endCall();
            }
          });
        },
        onError: (ErrorCodeType err, String msg) {
          print('Error: $err, $msg');
          callStatus.value = 'Error: $err';
        },
      ),
    );
  }
  
  void _startCallTimer() {
    _callTimer?.cancel();
    _secondsElapsed = 0;
    
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
      final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
      callDuration.value = '$minutes:$seconds';
    });
  }
  
  Future<void> toggleMute() async {
    if (engine == null) return;
    
    isMuted.value = !isMuted.value;
    await engine!.muteLocalAudioStream(isMuted.value);
  }
  
  Future<void> toggleSpeaker() async {
    if (engine == null) return;
    
    isSpeakerOn.value = !isSpeakerOn.value;
    await engine!.setEnableSpeakerphone(isSpeakerOn.value);
  }
  
  Future<void> switchCamera() async {
    if (engine == null || !isVideo.value) return;
    
    await engine!.switchCamera();
  }
  
  Future<void> endCall() async {
    try {
      // Stop the timer
      _callTimer?.cancel();
      
      // Leave the channel
      await _agoraService.leaveChannel();
      
      // Navigate back
      Get.back();
    } catch (e) {
      print('Error ending call: $e');
    }
  }
  
  @override
  void onClose() {
    // Clean up resources
    _callTimer?.cancel();
    endCall();
    super.onClose();
  }
}