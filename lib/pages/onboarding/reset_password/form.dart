import "dart:async";

import "package:flutter/material.dart";

import "../service.dart";
import "reset_password.dart";

class PasswordResetForm extends StatefulWidget {
  final Function next;
  final ResetPasswordState state;
  const PasswordResetForm({super.key, required this.next, required this.state});

  @override
  State<PasswordResetForm> createState() => _PasswordResetForm();
}

class _PasswordResetForm extends State<PasswordResetForm> {
  String _email = "";
  bool _loading = false;

  final _onboardingService = OnboardingService();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  Future<void> _resetUserPassword() async {
    try {
      print("Sending user reset password email");
      setState(() {
        _loading = true;
      });
      await _onboardingService.resetPassword(_email);
      widget.state.setEmail(_email);
      setState(() {
        _loading = false;
      });
      widget.next();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 30, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reset your Password",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  "Provide us the details of the email you used to log in the account",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: "Email Address",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _loading ? null : _resetUserPassword,
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
