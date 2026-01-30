class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? pengaduanId; // Related complaint/report

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.pengaduanId,
  });

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderRole,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? pengaduanId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      pengaduanId: pengaduanId ?? this.pengaduanId,
    );
  }

  @override
  String toString() =>
      'ChatMessage(id: $id, sender: $senderName, message: ${message.substring(0, (message.length > 20 ? 20 : message.length))}...)';
}

class Conversation {
  final String id;
  final String userId1;
  final String user1Name;
  final String user1Role;
  final String userId2;
  final String user2Name;
  final String user2Role;
  final List<ChatMessage> messages;
  final DateTime lastMessageTime;
  final String? pengaduanId;

  Conversation({
    required this.id,
    required this.userId1,
    required this.user1Name,
    required this.user1Role,
    required this.userId2,
    required this.user2Name,
    required this.user2Role,
    this.messages = const [],
    required this.lastMessageTime,
    this.pengaduanId,
  });

  Conversation copyWith({
    String? id,
    String? userId1,
    String? user1Name,
    String? user1Role,
    String? userId2,
    String? user2Name,
    String? user2Role,
    List<ChatMessage>? messages,
    DateTime? lastMessageTime,
    String? pengaduanId,
  }) {
    return Conversation(
      id: id ?? this.id,
      userId1: userId1 ?? this.userId1,
      user1Name: user1Name ?? this.user1Name,
      user1Role: user1Role ?? this.user1Role,
      userId2: userId2 ?? this.userId2,
      user2Name: user2Name ?? this.user2Name,
      user2Role: user2Role ?? this.user2Role,
      messages: messages ?? this.messages,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      pengaduanId: pengaduanId ?? this.pengaduanId,
    );
  }
}
