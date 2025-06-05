import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var currentUser = FirebaseAuth.instance.currentUser;
  var allUsers = <Map<String, dynamic>>[].obs;
  var acceptedUsers = <Map<String, dynamic>>[].obs;
  var searchResults = <Map<String, dynamic>>[].obs;

  // Map to track invitation status for each user (uid: status)
  var invitationStatusMap = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
    fetchAcceptedUsers();
    fetchAllInvitationsStatus();
  }

  void fetchAllUsers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      allUsers.value = snapshot.docs
          .where((doc) => doc.id != currentUser?.uid)
          .map((doc) => {'uid': doc.id, ...doc.data()})
          .toList();
    });
  }

  void fetchAcceptedUsers() {
    _firestore
        .collection('users')
        .doc(currentUser?.uid)
        .collection('invitations')
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> tempList = [];
      for (var doc in snapshot.docs) {
        var fromUid = doc['fromUid'];
        var userDoc = await _firestore.collection('users').doc(fromUid).get();
        if (userDoc.exists) {
          tempList.add({'uid': userDoc.id, ...userDoc.data()!});
        }
      }
      acceptedUsers.value = tempList;
    });
  }

  /// Fetch all invitations sent by the current user and track their status
  void fetchAllInvitationsStatus() {
    if (currentUser?.uid == null) return;
    _firestore.collection('users').get().then((usersSnapshot) {
      for (var userDoc in usersSnapshot.docs) {
        if (userDoc.id == currentUser!.uid) continue;
        _firestore
            .collection('users')
            .doc(userDoc.id)
            .collection('invitations')
            .doc(currentUser!.uid)
            .snapshots()
            .listen((invitationDoc) {
          if (invitationDoc.exists) {
            invitationStatusMap[userDoc.id] = invitationDoc['status'] ?? 'pending';
          } else {
            invitationStatusMap[userDoc.id] = '';
          }
        });
      }
    });
  }

  /// Send invitation and update status map
  void sendInvitation(String recipientUid) async {
    var invitationRef = _firestore
        .collection('users')
        .doc(recipientUid)
        .collection('invitations')
        .doc(currentUser?.uid);

    var doc = await invitationRef.get();
    if (!doc.exists) {
      await invitationRef.set({
        'fromUid': currentUser?.uid,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      invitationStatusMap[recipientUid] = 'pending';
    }
  }

  /// Search users by name or email (case-insensitive, prefix match)
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    final nameQuery = _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final emailQuery = _firestore
        .collection('users')
        .where('email', isGreaterThanOrEqualTo: query)
        .where('email', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final results = await Future.wait([nameQuery, emailQuery]);

    final Map<String, Map<String, dynamic>> userMap = {};

    for (var snapshot in results) {
      for (var doc in snapshot.docs) {
        if (doc.id != currentUser?.uid) {
          userMap[doc.id] = {'uid': doc.id, ...doc.data()};
        }
      }
    }

    searchResults.value = userMap.values.toList();
  }

  /// Helper to get invitation status for a user
  String getInvitationStatus(String uid) {
    return invitationStatusMap[uid] ?? '';
  }

  /// Helper to check if invitation is pending or sent
  bool isInvitationPending(String uid) {
    return invitationStatusMap[uid] == 'pending';
  }
  String formatTimestamp(dynamic timestamp) {
    if (timestamp is String) return timestamp;
    if (timestamp is DateTime) return timestamp.toString();
    if (timestamp is Timestamp) {
      final dt = timestamp.toDate();
      // Format as you like, e.g.:
      return "${dt.hour}:${dt.minute}"; //${dt.day}-${dt.month}-${dt.year}
    }
    return '';
  }
}