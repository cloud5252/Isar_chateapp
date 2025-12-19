import 'package:flutter/material.dart';
import 'package:isar_chateapp/Registration/login/login_view.dart';
import 'package:isar_chateapp/Registration/register/register_view.dart';

class LoginRegisterGate extends StatefulWidget {
  const LoginRegisterGate({super.key});

  @override
  State<LoginRegisterGate> createState() => _LoginRegisterGateState();
}

class _LoginRegisterGateState extends State<LoginRegisterGate> {
  bool isloginScreen = true;
  void toggleScreen() {
    setState(() {
      isloginScreen = !isloginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isloginScreen) {
      return LoginPage(ontap: toggleScreen);
    } else {
      return RegisterPage(ontap: toggleScreen);
    }
  }
}
