import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/messages.dart';

Future<void> sendMessage({
  required String SenderID,
  required String userId,
  required String societyId,
  required String text,
}) async {
  final message = Message(
    senderId: SenderID,
    message: text,
    timestamp: DateTime.now(),
    seen: false, // Default to false until read
  );

  // Use the lexicographically smaller and larger combination for consistency
  final conversationId = userId.compareTo(societyId) < 0
      ? '${userId}_$societyId'
      : '${societyId}_$userId';

  // Add message to Firestore under the appropriate conversation
  await FirebaseFirestore.instance
      .collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .add(message.toMap());

  // Update the main conversation document with the latest message and timestamp
  await FirebaseFirestore.instance
      .collection('conversations')
      .doc(conversationId)
      .set({
    'userId': userId,
    'societyId': societyId,
    'lastMessage': text,
    'lastMessageTimestamp': DateTime.now(),
  }, SetOptions(merge: true));
}

Stream<List<Message>> getMessages(
    {required String userId, required String societyId}) {
  final conversationId = userId.compareTo(societyId) < 0
      ? '${userId}_$societyId'
      : '${societyId}_$userId';

  return FirebaseFirestore.instance
      .collection('conversations')
      .doc(conversationId)
      .collection('messages')
      .orderBy('timestamp') // Sort messages by timestamp
      .snapshots()
      .map((snapshot) {
    // Convert Firestore documents to Message model objects
    return snapshot.docs.map((doc) {
      return Message.fromMap(doc.data());
    }).toList();
  });
}
