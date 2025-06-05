import 'package:agora_task/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'search_result.dart';
import 'user_view.dart';

Obx mainBody(HomeController controller) {
  return Obx(() {
    if (controller.searchResults.isNotEmpty) {
      return searchResult(controller);
    }
    if (controller.acceptedUsers.isEmpty) {
      return Center(child: Text('No accepted users.'));
    }
    return userView(controller);
  });
}