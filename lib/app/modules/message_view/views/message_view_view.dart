import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/message_view_controller.dart';

class MessageViewView extends GetView<MessageViewController> {
  const MessageViewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MessageViewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MessageViewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
