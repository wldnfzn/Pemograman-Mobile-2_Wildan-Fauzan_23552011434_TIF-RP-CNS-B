import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laporpak/models/notification.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final VoidCallback? onLike;
  final VoidCallback? onReply;
  final bool isLiked;

  const CommentCard({
    Key? key,
    required this.comment,
    this.onLike,
    this.onReply,
    this.isLiked = false,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('dd MMM HH:mm');
    final formattedTime = timeFormat.format(widget.comment.createdAt);

    // Get role color
    Color getRoleColor(String role) {
      switch (role.toLowerCase()) {
        case 'masyarakat':
          return Colors.blue;
        case 'admin':
          return Colors.red;
        case 'petugas':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name and role
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: getRoleColor(widget.comment.authorRole),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    widget.comment.authorName[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.comment.authorName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: getRoleColor(widget.comment.authorRole)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.comment.authorRole,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color:
                                  getRoleColor(widget.comment.authorRole),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          // Comment content
          Text(
            widget.comment.content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12),
          // Actions (Like, Reply)
          Row(
            children: [
              GestureDetector(
                onTap: widget.onLike,
                child: Row(
                  children: [
                    Icon(
                      widget.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 16,
                      color: widget.isLiked ? Colors.red : Colors.grey,
                    ),
                    SizedBox(width: 4),
                    Text(
                      widget.comment.likes.length > 0
                          ? '${widget.comment.likes.length}'
                          : 'Like',
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isLiked ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              if (widget.onReply != null)
                GestureDetector(
                  onTap: widget.onReply,
                  child: Row(
                    children: [
                      Icon(
                        Icons.reply,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
