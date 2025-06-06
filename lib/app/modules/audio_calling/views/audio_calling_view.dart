import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/audio_calling_controller.dart';

class AudioCallingView extends GetView<AudioCallingController> {
  const AudioCallingView({super.key});
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => Stack(
        children: [
          // Main call view
          Center(
            child: controller.isLoading.value
                ? const CircularProgressIndicator()
                : _buildCallView(),
          ),
          
          // Call controls at the bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: _buildCallControls(),
          ),
          
          // Call info at the top
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: _buildCallInfo(),
          ),
        ],
      )),
    );
  }

  Widget _buildCallView() {
    if (controller.remoteUid.value != 0) {
      // Remote user joined - show their video if it's a video call
      return controller.isVideo.value
          ? _buildRemoteVideo()
          : _buildAudioCallView();
    } else {
      // Waiting for remote user to join
      return controller.isVideo.value
          ? _buildLocalPreview()
          : _buildAudioCallView();
    }
  }

  Widget _buildLocalPreview() {
    return controller.engine != null
        ? AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: controller.engine!,
              canvas: const VideoCanvas(uid: 0),
            ),
          )
        : const Center(child: Text('Initializing video...', style: TextStyle(color: Colors.white)));
  }

  Widget _buildRemoteVideo() {
    return Stack(
      children: [
        // Remote video (full screen)
        controller.remoteUid.value != 0
            ? AgoraVideoView(
                controller: VideoViewController.remote(
                  rtcEngine: controller.engine!,
                  canvas: VideoCanvas(uid: controller.remoteUid.value),
                  connection: RtcConnection(channelId: controller.channelName),
                ),
              )
            : const Center(child: Text('Waiting for remote user...', style: TextStyle(color: Colors.white))),
        
        // Local video (picture-in-picture)
        Positioned(
          right: 20,
          top: 20,
          width: 120,
          height: 180,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: controller.engine != null
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: controller.engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                  : Container(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAudioCallView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2, color: Colors.white),
            ),
            child: ClipOval(
              child: controller.remoteUserPhoto.value.isNotEmpty
                  ? Image.network(controller.remoteUserPhoto.value, fit: BoxFit.cover)
                  : Image.asset('assets/images/young-men.png', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            controller.remoteUserName.value.isNotEmpty
                ? controller.remoteUserName.value
                : 'Connecting...',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            controller.callDuration.value,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCallControls() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.black38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute/Unmute button
          _buildControlButton(
            icon: controller.isMuted.value ? Icons.mic_off : Icons.mic,
            label: controller.isMuted.value ? 'Unmute' : 'Mute',
            onPressed: controller.toggleMute,
            backgroundColor: controller.isMuted.value ? Colors.red : Colors.white24,
          ),
          
          // End Call button
          _buildControlButton(
            icon: Icons.call_end,
            label: 'End',
            onPressed: controller.endCall,
            backgroundColor: Colors.red,
            iconColor: Colors.white,
          ),
          
          // Toggle camera button (only for video calls)
          if (controller.isVideo.value)
            _buildControlButton(
              icon: Icons.switch_camera,
              label: 'Switch',
              onPressed: controller.switchCamera,
              backgroundColor: Colors.white24,
            ),
          
          // Toggle speaker button
          _buildControlButton(
            icon: controller.isSpeakerOn.value ? Icons.volume_up : Icons.volume_off,
            label: controller.isSpeakerOn.value ? 'Speaker' : 'Earpiece',
            onPressed: controller.toggleSpeaker,
            backgroundColor: controller.isSpeakerOn.value ? Colors.green : Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white24,
    Color iconColor = Colors.white,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildCallInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.black38,
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Show confirmation dialog before leaving
              Get.dialog(
                AlertDialog(
                  title: const Text('End Call?'),
                  content: const Text('Are you sure you want to end this call?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        controller.endCall();
                      },
                      child: const Text('END', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          // Call type and duration
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.isVideo.value ? 'Video Call' : 'Audio Call',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() => Text(
                controller.callStatus.value,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              )),
            ],
          ),
        ],
      ),
    );
  }
}