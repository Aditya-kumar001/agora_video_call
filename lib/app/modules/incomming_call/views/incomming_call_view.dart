import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/incomming_call_controller.dart';

class IncommingCallView extends GetView<IncommingCallController> {
  const IncommingCallView({super.key});
 

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button from dismissing the incoming call screen
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              
              // Caller information
              _buildCallerInfo(),
              
              const Spacer(flex: 2),
              
              // Call actions (accept/decline)
              _buildCallActions(),
              
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallerInfo() {
    return Column(
      children: [
        // Call type indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            controller.isVideoCall.value ? 'Incoming Video Call' : 'Incoming Audio Call',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Caller avatar
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: ClipOval(
            child: controller.callerPhotoUrl.value.isNotEmpty
                ? Image.network(
                    controller.callerPhotoUrl.value,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white70,
                      );
                    },
                  )
                : const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white70,
                  ),
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Caller name
        Text(
          controller.callerName.value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 10),
        
        // Call status
        Text(
          'Calling...',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildCallActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Decline call button
        _buildActionButton(
          icon: Icons.call_end,
          backgroundColor: Colors.red,
          onPressed: controller.declineCall,
          label: 'Decline',
        ),
        
        // Accept call button
        _buildActionButton(
          icon: controller.isVideoCall.value ? Icons.videocam : Icons.call,
          backgroundColor: Colors.green,
          onPressed: controller.acceptCall,
          label: 'Accept',
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 30),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}