import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isar_chateapp/App/locator.locator.dart';
import 'package:isar_chateapp/Services/Isar_services/Isar_service.dart';
import 'package:isar_chateapp/models/UserModel.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  final TextEditingController nameController =
      TextEditingController();
  final TextEditingController emailController =
      TextEditingController();
  List<UserModel> users = [];
  bool isLoading = true;
  StreamSubscription<List<UserModel>>? _userSubscription;

  // HomeViewModel.dart mein
  void listenToUsers(String? myUid) {
    final String activeUid =
        myUid ?? FirebaseAuth.instance.currentUser?.uid ?? "";

    if (activeUid.isEmpty) return;

    isLoading = true;
    notifyListeners();

    _userSubscription?.cancel();
    _userSubscription =
        IsarService.watchAllUsers(activeUid).listen((userList) {
      users = userList.where((u) => u.uid != activeUid).toList();

      isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  void openeditBox(BuildContext context, UserModel userData) {
    final existingName = userData.name;
    final existingAmount = userData.email;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Expense'),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: existingName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: existingAmount,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
              emailController.clear();
            },
            child: const Text('Cancel'),
          ),
          editExpancesButton(context, userData),
        ],
      ),
    );
  }

  Widget editExpancesButton(
      BuildContext context, UserModel userData) {
    return MaterialButton(
      onPressed: () async {
        if (nameController.text.isNotEmpty ||
            emailController.text.isNotEmpty) {
          UserModel updateExpances = UserModel()
            ..id = userData.id
            ..uid = userData.uid
            ..name = nameController.text.isNotEmpty
                ? nameController.text
                : userData.name
            ..email = emailController.text.isNotEmpty
                ? emailController.text
                : userData.email
            ..timestamp = DateTime.now();

          Navigator.pop(context);

          await IsarService.isar.writeTxn(() async {
            await IsarService.isar.userModels.put(updateExpances);
          });

          nameController.clear();
          emailController.clear();
        }
      },
      child: const Text('Save'),
    );
  }

  void openDeleteBox(BuildContext context, UserModel data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete expense?'),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
              emailController.clear();
            },
            child: const Text('Cancel'),
          ),
          locator<IsarService>().deleteExpancesButton(context, data.id),
        ],
      ),
    );
  }
}
