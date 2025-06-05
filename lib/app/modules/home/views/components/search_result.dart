import 'package:agora_task/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

ListView searchResult(HomeController controller) {
  return ListView.builder(
    itemCount: controller.searchResults.length,
    itemBuilder: (context, index) {
      var user = controller.searchResults[index];
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
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
          title: Text(user['name'] ?? ''),
          subtitle: Text(user['email'] ?? ''),
          // onTap: () {
          //   Get.toNamed(Routes.MESSAGE_VIEW, arguments: {
          //     'uid': user['uid'],
          //     'name': user['name'],
          //     'photoUrl': user['photoUrl'],
          //   });
          // },
          trailing: Obx(() {
            final status = controller.getInvitationStatus(user['uid']);
            if (status == 'pending') {
              return ElevatedButton(
                onPressed: null,
                child: Text('Invitation Sent'),
              );
            }
            return ElevatedButton(
              onPressed: () {
                controller.sendInvitation(user['uid']);
              },
              child: Text('Send Invitation'),
            );
          }),
        ),
      );
    },
  );
}