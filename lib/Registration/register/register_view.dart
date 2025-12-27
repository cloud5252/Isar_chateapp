import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../components/My_button.dart';
import '../../components/My_text_fields.dart';
import 'register_view_model.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? ontap;

  const RegisterPage({super.key, required this.ontap});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.reactive(
        viewModelBuilder: () => RegisterViewModel(),
        builder: (context, viewmodel, child) {
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
                    const SizedBox(height: 50),
                    Text(
                      'Lets`s create account for you',
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    MyTextFeilds(
                      hinttext: 'Name',
                      obsecurtext: false,
                      controller: viewmodel.userNamecontroller,
                    ),
                    const SizedBox(height: 10),
                    MyTextFeilds(
                      hinttext: 'Email',
                      obsecurtext: false,
                      controller: viewmodel.Emailcontroller,
                    ),
                    const SizedBox(height: 10),
                    MyTextFeilds(
                      hinttext: 'Password',
                      obsecurtext: false,
                      controller: viewmodel.passwordcontroller,
                    ),
                    const SizedBox(height: 10),
                    MyTextFeilds(
                      hinttext: 'Confirm password',
                      obsecurtext: false,
                      controller:
                          viewmodel.conformedpasswordcontroller,
                    ),
                    const SizedBox(height: 30),
                    MyButton(
                      text: 'Register',
                      ontap: () => viewmodel.register(
                        context,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Allready have an account? ',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: ontap,
                          child: Text(
                            'Login now',
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
