import 'package:flutter/material.dart';
import 'package:laporpak/models/user.dart';
import 'package:laporpak/services/chat_service.dart';
import 'package:laporpak/widgets/chat_bubble.dart';
import 'package:laporpak/widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  final User currentUser;
  final String? pengaduanId;

  const ChatScreen({
    Key? key,
    required this.currentUser,
    this.pengaduanId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _chatService = ChatService();
  late String _conversationId;
  late String _recipientName;

  @override
  void initState() {
    super.initState();
    // Determine recipient based on user role
    if (widget.currentUser.role == 'masyarakat') {
      _recipientName = 'Admin';
      _conversationId = 'conv_${widget.currentUser.id}_admin';
    } else {
      _recipientName = 'Masyarakat';
      _conversationId = 'conv_${widget.currentUser.id}_community';
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    _chatService.sendMessage(
      conversationId: _conversationId,
      senderId: widget.currentUser.id,
      senderName: widget.currentUser.name,
      senderRole: widget.currentUser.role,
      receiverId: widget.currentUser.role == 'masyarakat' ? 'admin' : 'masyarakat',
      message: _messageController.text.trim(),
      pengaduanId: widget.pengaduanId,
    );

    _messageController.clear();
    setState(() {});
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _chatService.getConversationMessages(_conversationId);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chat dengan $_recipientName',
        backgroundColor: Colors.blue[600]!,
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada pesan',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isCurrentUser =
                          message.senderId == widget.currentUser.id;

                      return ChatBubble(
                        message: message,
                        isCurrentUser: isCurrentUser,
                      );
                    },
                  ),
          ),
          // Input field
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
