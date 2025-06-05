import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  
  var searchResults = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var currentUser = FirebaseAuth.instance.currentUser;
  var allUsers = <Map<String, dynamic>>[].obs;
  var acceptedUsers = <Map<String, dynamic>>[].obs;

  final box = GetStorage();


  @override
  void onInit() {
    super.onInit();
    final query = box.read('uid');
    searchProfile(query);
  }

  Future<void> searchProfile(String query) async {

    final nameQuery = _firestore
        .collection('users')
        .where('uid', isGreaterThanOrEqualTo: query)
        .where('uid', isLessThanOrEqualTo: query + '\uf8ff')
        .get();



    final results = await Future.wait([nameQuery]);

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


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
