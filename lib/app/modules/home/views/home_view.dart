import 'package:agora_task/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import 'components/main_body.dart';
import 'components/search_bar.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Messages'),
      body: Obx(() =>
        Column(
          children: [
            // Search Bar
            if (controller.searchBar.value) 
              searchBar(context, controller),
            // User List
            Expanded(
              child: mainBody(controller),
            ),
          ],
        ),
      ),
    );
  }  
}