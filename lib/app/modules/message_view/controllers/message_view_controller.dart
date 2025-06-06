import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/agora_service.dart';
import '../../../routes/app_pages.dart';

class MessageViewController extends GetxController {
  final AgoraService _agoraService = Get.find<AgoraService>();
  
  RxString userName = ''.obs;
  RxString photoUrl = ''.obs;
  RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize user data - replace with your actual data source
    userName.value = Get.arguments?['userName'] ?? 'User';
    photoUrl.value = Get.arguments?['photoUrl'] ?? '';
    
    // Initialize Agora service if not already initialized
    _initializeAgoraService();
  }
  
  Future<void> _initializeAgoraService() async {
    try {
      await _agoraService.initialize();
    } catch (e) {
      print('Error initializing Agora service: $e');
      Get.snackbar('Error', 'Failed to initialize call service');
    }
  }
  
  Future<void> joinCall({
    required String token,
    required bool isVideo,
    required String channelName,
  }) async {
    isLoading.value = true;
    
    // Request permissions first
    if (!await _handlePermissions(isVideo)) {
      isLoading.value = false;
      return;
    }
    
    try {
      // Generate a fresh token if needed
      // final String validToken = await _getValidToken(channelName);
      
      // if (validToken.isEmpty) {
      //   Get.snackbar('Error', 'Failed to get a valid token for the call');
      //   isLoading.value = false;
      //   return;
      // }
      
      // Navigate to call screen with parameters
      Get.toNamed(
        Routes.AUDIO_CALLING, // Make sure you have this route defined
        arguments: {
          'channelName': channelName,
          'token': AgoraService.tempToken,
          'isVideo': isVideo,
          'userName': userName.value,
          'photoUrl': photoUrl.value,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error joining call: $e');
      }
      
      Get.snackbar('Error', 'Failed to join the call. Please try again. $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<bool> _handlePermissions(bool isVideo) async {
    // Request microphone permission for both audio and video calls
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
    ].request();
    
    if (statuses[Permission.microphone] != PermissionStatus.granted) {
      Get.snackbar('Permission Denied', 
        'Microphone permission is required for calls');
      return false;
    }
    
    // For video calls, also request camera permission
    if (isVideo) {
      PermissionStatus cameraStatus = await Permission.camera.request();
      if (cameraStatus != PermissionStatus.granted) {
        Get.snackbar('Permission Denied', 
          'Camera permission is required for video calls');
        return false;
      }
    }
    
    return true;
  }
  
  // Future<String> _getValidToken(String channelName) async {
  //   try {
  //     // Replace this with your actual token generation logic
  //     // This could be a call to your backend to generate a token
  //     return await _agoraService.generateToken(channelName);
  //   } catch (e) {
  //     print('Error generating token: $e');
  //     return '';
  //   }
  // }
  
  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}