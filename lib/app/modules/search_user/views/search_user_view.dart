import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_user_controller.dart';

class SearchUserView extends GetView<SearchUserController> {
  const SearchUserView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SearchUserView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SearchUserView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
