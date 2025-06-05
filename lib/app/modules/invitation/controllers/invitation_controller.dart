import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvitationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  var invitations = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvitations();
  }

  void fetchInvitations() {
    if (currentUser == null) {
      invitations.value = [];
      return;
    }
    isLoading.value = true;
    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('invitations')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> tempList = [];
      for (var doc in snapshot.docs) {
        var fromUid = doc['fromUid'];
        var userDoc = await _firestore.collection('users').doc(fromUid).get();
        if (userDoc.exists) {
          tempList.add({
            'invitationId': doc.id,
            'fromUid': fromUid,
            'status': doc['status'],
            ...userDoc.data()!,
          });
        }
      }
      invitations.value = tempList;
      isLoading.value = false;
    });
  }

  Future<void> acceptInvitation(String fromUid) async {
    if (currentUser == null) return;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('invitations')
        .doc(fromUid)
        .update({'status': 'accepted'});
  }

  Future<void> declineInvitation(String fromUid) async {
    if (currentUser == null) return;
    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('invitations')
        .doc(fromUid)
        .update({'status': 'declined'});
  }
}