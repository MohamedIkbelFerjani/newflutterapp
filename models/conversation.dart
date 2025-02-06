class Conversation {
  String userId;
  String societyId;

  Conversation({
    required this.userId,
    required this.societyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'societyId': societyId,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      userId: map['userId'],
      societyId: map['societyId'],
    );
  }
}
