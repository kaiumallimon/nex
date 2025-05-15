class Message {
  final String id;
  final String conversationId;
  final String sender;
  final String content;
  final String responseType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.content,
    required this.responseType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      sender: json['sender'] ?? '',
      content: json['content'] ?? '',
      responseType: json['response_type'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'sender': sender,
      'content': content,
      'response_type': responseType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
