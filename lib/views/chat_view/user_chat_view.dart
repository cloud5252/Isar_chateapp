import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isar_chateapp/models/UserModel.dart';
import 'package:isar_chateapp/views/chat_view/component/chat_input_field.dart';

import 'package:isar_chateapp/views/chat_view/user_chat_view_model.dart';
import 'package:stacked/stacked.dart';

class UserChatView extends StatefulWidget {
  final String currentUserId;
  final String receiverId;
  final String senderName;
  final String receiverEmail;

  const UserChatView({
    Key? key,
    required this.currentUserId,
    required this.receiverId,
    required this.senderName,
    required this.receiverEmail,
  }) : super(key: key);

  @override
  State<UserChatView> createState() => _UserChatViewState();
}

class _UserChatViewState extends State<UserChatView> {
  final TextEditingController controller = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String get currentUserId => _firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserChatViewModel>.nonReactive(
        viewModelBuilder: () => UserChatViewModel(),
        onViewModelReady: (model) {
          List<String> ids = [
            widget.currentUserId,
            widget.receiverId
          ];
          ids.sort();
          String roomID = ids.join('_');
          model.updateChatRoomId(roomID);
          model.initializeChatRoom(
              widget.currentUserId, widget.receiverId);
        },
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.grey.shade100,
              title: Text(widget.senderName),
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new)),
            ),
            body: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  Expanded(child: buildmessageslist(viewModel)),
                  _buildMessageInput(viewModel),
                  SizedBox(
                      height:
                          MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          );
        });
  }

  Widget buildmessageslist(UserChatViewModel viewModel) {
    return StreamBuilder<List<ChatMessage>>(
      stream: viewModel.messagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading messages'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data ?? [];

        if (messages.isEmpty) {
          return const Center(child: Text('No messages yet...'));
        }

        return Align(
          alignment: Alignment.topCenter,
          child: ListView.builder(
            key: const PageStorageKey('chat_list'),
            reverse: true,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              bool isMe = message.senderId == widget.currentUserId;
              return _buildMessageBubble(message, isMe);
            },
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.messageText,
              style: TextStyle(
                  fontSize: 17,
                  color: isMe ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 14,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput(UserChatViewModel viewmodel) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        child: ChatInputField(
          controller: controller,
          onSend: () => viewmodel.sendMessage(
              senderId: currentUserId,
              senderEmail: widget.receiverEmail,
              receiverId: widget.receiverId,
              messageText: controller.text,
              controller: controller),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
