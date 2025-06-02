import 'package:agora_task/app/common/app_color.dart';
import 'package:agora_task/app/common/app_fontWeight.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facetime',
          style: TextStyle(
            fontSize: 24,
            fontWeight: AppFontWeight.font3,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.notifications,
          //   ),
          //   onPressed: () {
          //     // Handle notifications action
          //   },
          // ),
        ],
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: 20, // Replace with your dynamic item count
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.MESSAGE_VIEW);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: 0.5,
                  //   color: AppColorList.AppText,
                  // ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          // Handle profile picture tap
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        "assets/images/app_icon.png",
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.1,
                          decoration: BoxDecoration(
                            // border: Border.all(
                            //   width: 0.5,
                            //   color: AppColorList.AppText,
                            // ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              "assets/images/app_icon.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Aditya Kumar Harijan",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: AppFontWeight.font3,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.015),
                        Text(
                          "Software Engineer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: AppFontWeight.font2,
                            color: AppColorList.AppText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "12-12-2025",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: AppFontWeight.font2,
                          color: AppColorList.AppText,
                        ),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}