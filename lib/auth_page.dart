// ignore_for_file: must_be_immutable

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

final formKey = GlobalKey<FormState>();

class AuthPage extends ConsumerWidget {
  AuthPage({super.key});

  var password = "my client secret";
  var driverID = "my client identifier";
  final tokenEndpoint =
      Uri.parse('https://mobileapi.nussbaum.com/api/DEMO/token');

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Future<dynamic> fetchToken() {
  //   var headers = {'password': '', 'driverid': ''};
  // }

  ElevatedButton submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          driverID = emailController.value.text;
          password = passwordController.value.text;
          print('user: $driverID, password: $password');
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
            submitButton(context),
          ],
        ),
      ),
    );
  }
}
