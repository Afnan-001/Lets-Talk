import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // Fetch the current user's ID and name
  static Future<Map<String, String>?> fetchCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          return {
            'id': user.uid,
            'name': userDoc.data()?['name'] ?? 'Unknown',
          };
        }
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  // Get the message stream for a specific group
  static Stream<QuerySnapshot> getMessagesStream(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Send a message to the group
  static Future<void> sendMessage({
    required String groupId,
    required String userId,
    required String userName,
    required String content,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .add({
        'senderID': userId,
        'senderName': userName,
        'timestamp': FieldValue.serverTimestamp(),
        'content': content,
        'messageType': 'text',
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
