import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String otherUserId;
  final String? otherUserName;
  final String? otherUserAvatar;

  ChatScreen({
    required this.chatId,
    required this.otherUserId,
    this.otherUserName,
    this.otherUserAvatar,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final FocusNode _focusNode = FocusNode();

  bool _isTyping = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _isTyping) {
      setState(() {
        _isTyping = hasText;
      });
      if (hasText) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add haptic feedback
    HapticFeedback.lightImpact();

    final timestamp = Timestamp.now();
    _controller.clear();
    _scrollToBottom();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'senderId': currentUserId,
      'text': text,
      'timestamp': timestamp,
    });

    await FirebaseFirestore.instance.collection('chats').doc(widget.chatId).set({
      'userIds': [currentUserId, widget.otherUserId],
      'lastMessage': text,
      'lastUpdated': timestamp,
    }, SetOptions(merge: true));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatTime(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();

    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return DateFormat('HH:mm').format(date);
    } else if (date.year == now.year) {
      return DateFormat('MMM dd, HH:mm').format(date);
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  Widget _buildMessage(DocumentSnapshot msg, bool isMe, bool showAvatar) {
    return Container(
      margin: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isMe ? 50 : 8,
        right: isMe ? 8 : 50,
      ),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe && showAvatar)
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              backgroundImage: widget.otherUserAvatar != null
                  ? NetworkImage(widget.otherUserAvatar!)
                  : null,
              child: widget.otherUserAvatar == null
                  ? Icon(Icons.person, size: 18, color: Theme.of(context).primaryColor)
                  : null,
            )
          else if (!isMe)
            SizedBox(width: 32),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg['text'],
                    style: TextStyle(
                      color: isMe
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(msg['timestamp']),
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withOpacity(0.7)
                          : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              backgroundImage: widget.otherUserAvatar != null
                  ? NetworkImage(widget.otherUserAvatar!)
                  : null,
              child: widget.otherUserAvatar == null
                  ? Icon(Icons.person, color: theme.primaryColor)
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.otherUserName ?? 'Chat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam_outlined),
            onPressed: () {
              // Video call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.call_outlined),
            onPressed: () {
              // Voice call functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    theme.colorScheme.background,
                    theme.colorScheme.background.withOpacity(0.8),
                  ],
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    );
                  }

                  final messages = snapshot.data!.docs;
                  

                  if (messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: theme.colorScheme.onBackground.withOpacity(0.3),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Start your conversation',
                            style: TextStyle(
                              fontSize: 18,
                              color: theme.colorScheme.onBackground.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Auto-scroll to bottom when new messages arrive
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollToBottom();
                    }
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isMe = msg['senderId'] == currentUserId;
                      final showAvatar = index == 0 ||
                          messages[index - 1]['senderId'] != msg['senderId'];

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _buildMessage(msg, isMe, showAvatar),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    color: theme.primaryColor,
                    onPressed: () {
                      // Show attachment options
                    },
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(
                            color: theme.colorScheme.onBackground.withOpacity(0.5),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        maxLines: 4,
                        minLines: 1,
                        textCapitalization: TextCapitalization.sentences,
                        onSubmitted: (text) {
                          sendMessage(text);
                          _focusNode.requestFocus();
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _isTyping
                              ? theme.primaryColor
                              : theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isTyping ? Icons.send_rounded : Icons.mic_rounded,
                            color: _isTyping
                                ? Colors.white
                                : theme.primaryColor,
                          ),
                          onPressed: () {
                            if (_isTyping) {
                              sendMessage(_controller.text.trim());
                            } else {
                              // Voice message functionality
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}