import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isar_chateapp/App/locator.locator.dart';
import 'package:isar_chateapp/Services/Authentication.dart';
import 'package:isar_chateapp/components/My_list_tile.dart';
import 'package:isar_chateapp/views/Home_view/home_view_model.dart';
import 'package:isar_chateapp/views/chat_view/user_chat_view.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final auth = locator<Authentication>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) {
        // Locator se auth class lein
        final authService = locator<Authentication>();
        final currentId = authService.user?.uid ??
            FirebaseAuth.instance.currentUser?.uid;

        if (currentId != null) {
          viewModel.listenToUsers(currentId);
        }
      },
      builder: (context, viewmodel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey.shade100,
            title: const Text('Home'),
            // HomeView.dart mein AppBar leading
            leading: IconButton(
              onPressed: () {
                final freshId =
                    FirebaseAuth.instance.currentUser?.uid;
                if (freshId != null) {
                  viewmodel.listenToUsers(freshId);
                }
              },
              icon: const Icon(Icons.refresh),
            ),
            actions: [
              IconButton(
                  onPressed: () => auth.logOut(),
                  icon: const Icon(Icons.logout)),
            ],
            centerTitle: true,
          ),
          body: viewmodel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : viewmodel.users.isEmpty
                  ? const Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: viewmodel.users.length,
                      itemBuilder: (context, index) {
                        final user = viewmodel.users[index];

                        return MyListTile(
                            title: user.name,
                            trailing: user.email,
                            date: user.timestamp.toString(),
                            onEditPressed: (BuildContext context) =>
                                viewmodel.openeditBox(context, user),
                            onDeletePressed: (BuildContext context) =>
                                viewmodel.openDeleteBox(
                                    context, user),
                            ontap: () {
                              final myId = FirebaseAuth
                                      .instance.currentUser?.uid ??
                                  '';
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserChatView(
                                    currentUserId: myId,
                                    receiverId: user.uid,
                                    senderName: user.name,
                                    receiverEmail: user.email,
                                  ),
                                ),
                              );
                            });
                      },
                    ),
        );
      },
    );
  }
}
