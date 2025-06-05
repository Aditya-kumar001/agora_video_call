import 'package:agora_task/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/app_fontWeight.dart';
import '../../../../common/app_fontsize.dart';
import '../../../../routes/app_pages.dart';

ListView userView(HomeController controller) {
  return ListView.builder(
    itemCount: controller.acceptedUsers.length,
    itemBuilder: (context, index) {
      var user = controller.acceptedUsers[index];
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[100],
          // border: Border.all(
          //   width: 0.5,
          //   color: Colors.black,
          // ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user['photoUrl'] ?? ''),
          ),
          title: Text(
            user['name'] ?? '',
            style: TextStyle(
              fontSize: AppFontSize.size2,
              fontWeight: AppFontWeight.font3,
            ),  
          ),
          subtitle: Text(
            user['email'] ?? '',
            style: TextStyle(
              fontSize: AppFontSize.size5,
              fontWeight: AppFontWeight.font3,
            ),  
          ),
          onTap: () {
            Get.toNamed(Routes.MESSAGE_VIEW, arguments: {
              'uid': user['uid'],
              'name': user['name'],
              'photoUrl': user['photoUrl'],
            });
          },
          trailing: Text(
            user['lastLogin'] != null
                ? controller.formatTimestamp(user['lastLogin'])
                : 'No login',
            style: TextStyle(
              fontSize: AppFontSize.size2,
              fontWeight: AppFontWeight.font3,
            ),  
          ),
        ),
      );
    },
  );
}