import 'package:flutter/material.dart';
import 'package:isar_chateapp/views/chat_view/user_chat_view_model.dart';
import 'package:stacked/stacked.dart';

class UserChatView extends StatelessWidget {
  const UserChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserChatViewModel>.reactive(
        viewModelBuilder: () => UserChatViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new)),
              centerTitle: true,
              backgroundColor: Colors.lightGreenAccent,
              title: Text('Chat Room'),
            ),
          );
        });
  }
}
