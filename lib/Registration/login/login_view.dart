import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../components/My_button.dart';
import '../../components/My_text_fields.dart';
import 'login_view_model.dart';

class LoginPage extends StatelessWidget {
  final void Function()? ontap;

  LoginPage({super.key, required this.ontap});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.message,
                      size: 60,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Welcome back you`ve been missed!',
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 30),
                    MyTextFeilds(
                      hinttext: 'Email',
                      obsecurtext: false,
                      controller: viewModel.Emailcontroller,
                    ),
                    SizedBox(height: 10),
                    MyTextFeilds(
                      hinttext: 'Password',
                      obsecurtext: false,
                      controller: viewModel.passwordcontroller,
                    ),
                    SizedBox(height: 30),
                    MyButton(
                        text: 'Login',
                        ontap: () => viewModel.Login(context)),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not a member? ',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: ontap,
                          child: Text(
                            'Register now',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
