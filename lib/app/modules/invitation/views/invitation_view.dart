import 'package:agora_task/app/common/app_fontWeight.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../controllers/invitation_controller.dart';

class InvitationView extends StatelessWidget {
  InvitationView({super.key});
  final InvitationController controller = Get.put(InvitationController(), permanent: false);

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Invitations'),
      body: Obx(() {
        if (controller.currentUser == null) {
          return const Center(
            child: Text(
              'You must be logged in to view invitations.',
              style: TextStyle(fontSize: 20),
            ),
          );
        }
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.invitations.isEmpty) {
          return const Center(
            child: Text(
              'No pending invitations.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: AppFontWeight.font3
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.invitations.length,
          itemBuilder: (context, index) {
            final invitation = controller.invitations[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundImage: invitation['photoUrl'] != null && invitation['photoUrl'] != ''
                            ? NetworkImage(invitation['photoUrl'])
                            : null,
                        child: (invitation['photoUrl'] == null || invitation['photoUrl'] == '')
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(invitation['name'] ?? 'Unknown'),
                      subtitle: Text(invitation['email'] ?? ''),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            controller.acceptInvitation(invitation['fromUid']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: AppFontWeight.font3,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            controller.declineInvitation(invitation['fromUid']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Decline',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: AppFontWeight.font3,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ),
              ),
              );
          },
        );
      }),
    );
  }
}