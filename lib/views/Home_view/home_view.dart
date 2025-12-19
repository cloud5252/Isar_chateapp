import 'package:flutter/material.dart';
import 'package:isar_chateapp/App/locator.locator.dart';
import 'package:isar_chateapp/Services/Authentication.dart';
import 'package:isar_chateapp/components/My_list_tile.dart';
import 'package:isar_chateapp/views/Home_view/home_view_model.dart';
import 'package:isar_chateapp/views/chat_view/user_chat_view.dart';
import 'package:stacked/stacked.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  HomeView({super.key});
  final auth = locator<Authentication>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (viewModel) => viewModel.listenToUsers(),
      builder: (context, viewmodel, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightGreenAccent,
            title: const Text('Home'),
            leading: IconButton(
              onPressed: () => viewmodel.listenToUsers(),
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
                              viewmodel.openDeleteBox(context, user),
                          ontap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserChatView(),
                            ),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
