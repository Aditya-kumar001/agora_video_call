// services/call_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> startCall(String callerId, String receiverId, String channel) async {
  await FirebaseFirestore.instance.collection('calls').add({
    'callerId': callerId,
    'receiverId': receiverId,
    'channel': channel,
    'timestamp': FieldValue.serverTimestamp(),
  });

  // Send FCM push to receiver (via Firebase Function or admin SDK)
}
