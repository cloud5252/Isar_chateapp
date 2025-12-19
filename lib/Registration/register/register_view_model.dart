import 'package:flutter/material.dart';
import 'package:isar_chateapp/App/locator.locator.dart';
import 'package:isar_chateapp/Services/Authentication.dart';
import 'package:stacked/stacked.dart';

class RegisterViewModel extends BaseViewModel {
  final TextEditingController Emailcontroller =
      TextEditingController();
  final TextEditingController passwordcontroller =
      TextEditingController();
  final TextEditingController conformedpasswordcontroller =
      TextEditingController();
  final TextEditingController userNamecontroller =
      TextEditingController();

  void register(
    BuildContext context,
  ) async {
    final auth = locator<Authentication>();
    if (conformedpasswordcontroller.text == passwordcontroller.text) {
      try {
        auth.createdAccount(
          userNamecontroller.text,
          Emailcontroller.text,
          passwordcontroller.text,
          context,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text('Password do not Match!')),
      );
    }
  }
}
