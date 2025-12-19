import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../App/locator.locator.dart';
import '../../Services/Authentication.dart';

class LoginViewModel extends BaseViewModel {
  final Emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  void Login(BuildContext context) async {
    final auth = locator<Authentication>();

    try {
      await auth.signIn(
        Emailcontroller.text,
        passwordcontroller.text,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text(e.toString())),
      );
    }
  }
}
