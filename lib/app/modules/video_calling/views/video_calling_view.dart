import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/video_calling_controller.dart';

class VideoCallingView extends GetView<VideoCallingController> {
  const VideoCallingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VideoCallingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VideoCallingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
