import 'package:laporpak/models/chat_message.dart';
import 'dart:math';

class ChatService {
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal();

  // Simulated database
  final List<Conversation> conversations = [];
  final List<ChatMessage> allMessages = [];

  // Create or get conversation
  Conversation getOrCreateConversation({
    required String userId1,
    required String user1Name,
    required String user1Role,
    required String userId2,
    required String user2Name,
    required String user2Role,
    String? pengaduanId,
  }) {
    // Check if conversation already exists
    final existingConversation = conversations.firstWhere(
      (c) =>
          (c.userId1 == userId1 && c.userId2 == userId2) ||
          (c.userId1 == userId2 && c.userId2 == userId1),
      orElse: () => throw Exception('Not found'),
    );

    if (existingConversation.toString() != 'Exception') {
      return existingConversation;
    }

    // Create new conversation
    final newConversation = Conversation(
      id: _generateId(),
      userId1: userId1,
      user1Name: user1Name,
      user1Role: user1Role,
      userId2: userId2,
      user2Name: user2Name,
      user2Role: user2Role,
      lastMessageTime: DateTime.now(),
      pengaduanId: pengaduanId,
    );

    conversations.add(newConversation);
    return newConversation;
  }

  // Send message
  Future<ChatMessage?> sendMessage({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String senderRole,
    required String receiverId,
    required String message,
    String? pengaduanId,
  }) async {
    await Future.delayed(Duration(milliseconds: 200));

    try {
      final newMessage = ChatMessage(
        id: _generateId(),
        conversationId: conversationId,
        senderId: senderId,
        senderName: senderName,
        senderRole: senderRole,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now(),
        pengaduanId: pengaduanId,
      );

      allMessages.add(newMessage);

      // Update conversation
      final convIndex = conversations.indexWhere((c) => c.id == conversationId);
      if (convIndex != -1) {
        final conversation = conversations[convIndex];
        final updatedMessages = List<ChatMessage>.from(conversation.messages);
        updatedMessages.add(newMessage);

        conversations[convIndex] = conversation.copyWith(
          messages: updatedMessages,
          lastMessageTime: DateTime.now(),
        );
      }

      return newMessage;
    } catch (e) {
      return null;
    }
  }

  // Get conversation messages
  List<ChatMessage> getConversationMessages(String conversationId) {
    return allMessages
        .where((m) => m.conversationId == conversationId)
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  // Get user conversations
  List<Conversation> getUserConversations(String userId) {
    return conversations
        .where(
          (c) =>
              c.userId1 == userId ||
              c.userId2 == userId,
        )
        .toList()
      ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
  }

  // Get unread message count
  int getUnreadCount(String userId) {
    return allMessages
        .where((m) => m.receiverId == userId && !m.isRead)
        .length;
  }

  // Mark messages as read
  void markAsRead(String conversationId, String userId) {
    final messageIndices = <int>[];

    for (int i = 0; i < allMessages.length; i++) {
      final msg = allMessages[i];
      if (msg.conversationId == conversationId &&
          msg.receiverId == userId &&
          !msg.isRead) {
        messageIndices.add(i);
      }
    }

    for (int i in messageIndices) {
      allMessages[i] = allMessages[i].copyWith(isRead: true);
    }
  }

  // Get conversation by ID
  Conversation? getConversationById(String conversationId) {
    try {
      return conversations.firstWhere((c) => c.id == conversationId);
    } catch (e) {
      return null;
    }
  }

  // Find existing conversation between two users
  Conversation? findConversation(String userId1, String userId2) {
    try {
      return conversations.firstWhere(
        (c) =>
            (c.userId1 == userId1 && c.userId2 == userId2) ||
            (c.userId1 == userId2 && c.userId2 == userId1),
      );
    } catch (e) {
      return null;
    }
  }

  // Generate unique ID
  String _generateId() {
    return 'id_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }
}
