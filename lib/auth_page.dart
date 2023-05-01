// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final formKey = GlobalKey<FormState>();

class EmailNotifier extends StateNotifier<String> {
  EmailNotifier() : super("Email");
  void setEmail(String email) {
    state = email;
  }
}

class PasswordNotifier extends StateNotifier<String> {
  PasswordNotifier() : super("Password");
  void setPassword(String pw) {
    state = pw;
  }
}

final passwordProvider = StateNotifierProvider<PasswordNotifier, String>((ref) {
  return PasswordNotifier();
});

final emailProvider = StateNotifierProvider<EmailNotifier, String>((ref) {
  return EmailNotifier();
});

class AuthPage extends ConsumerWidget {
  AuthPage({super.key});

  final tokenEndpoint =
      Uri.parse('https://mobileapi.nussbaum.com/api/DEMO/token');

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Future<dynamic> fetchToken() {
  //   var headers = {'password': '', 'driverid': ''};
  // }

  ElevatedButton submitButton(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          ref.read(emailProvider.notifier).setEmail(emailController.value.text);
          ref
              .read(passwordProvider.notifier)
              .setPassword(passwordController.value.text);
          //print('user: $driverID, password: $password');
        }

        FocusScopeNode focus = FocusScope.of(context);
        if (!focus.hasPrimaryFocus) {
          focus.unfocus();
        }
      },
      child: const Text("Login"),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    emailController.text = ref.watch(emailProvider);
    passwordController.text = ref.watch(passwordProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Driver ID";
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password";
                } else {
                  return null;
                }
              },
            ),
            submitButton(context, ref),
          ],
        ),
      ),
    );
  }
}
