import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_page/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String groupId;

  const ChatPage({super.key, required this.groupId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  String? _currentUserId;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final userData = await ChatService.fetchCurrentUser();
    if (userData != null) {
      setState(() {
        _currentUserId = userData['id'];
        _currentUserName = userData['name'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ChatService.getMessagesStream(widget.groupId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No messages yet.",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageItem(message);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final content = _messageController.text.trim();
                    if (content.isNotEmpty && _currentUserId != null) {
                      ChatService.sendMessage(
                        groupId: widget.groupId,
                        userId: _currentUserId!,
                        userName: _currentUserName ?? 'Unknown',
                        content: content,
                      );
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(QueryDocumentSnapshot message) {
    final senderName = message['senderName'] ?? 'Unknown';
    final content = message['content'] ?? '';
    final timestamp = (message['timestamp'] as Timestamp?)?.toDate();
    final messageType = message['messageType'] ?? 'text';

    return ListTile(
      leading: CircleAvatar(
        child: Text(senderName[0]),
      ),
      title: Text(
        senderName,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      subtitle: messageType == 'text'
          ? Text(
              content,
              style: const TextStyle(color: Colors.white),
            )
          : messageType == 'image'
              ? const Text("[Image Message]")
              : const Text("[Unsupported message type]"),
      trailing: timestamp != null
          ? Text(DateFormat('hh:mm a').format(timestamp))
          : null,
    );
  }
}
