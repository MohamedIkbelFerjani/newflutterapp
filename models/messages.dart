class Message {
  String senderId;
  String message;
  DateTime timestamp;
  bool seen;

  Message({
    required this.senderId,
    required this.message,
    required this.timestamp,
    this.seen = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
      'seen': seen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      message: map['message'],
      timestamp: (map['timestamp']).toDate(),
      seen: map['seen'] ?? false,
    );
  }
}
