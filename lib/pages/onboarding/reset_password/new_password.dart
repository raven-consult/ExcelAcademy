import 'package:flutter/material.dart';

import '../service.dart';
import 'reset_password.dart';

class NewPasswordForm extends StatefulWidget {
  final Function next;
  final ResetPasswordState state;
  const NewPasswordForm({super.key, required this.next, required this.state});

  @override
  State<NewPasswordForm> createState() => _NewPasswordForm();
}

class _NewPasswordForm extends State<NewPasswordForm> {
  final _onboardingService = OnboardingService();

  String? _passwordError;
  String? _confirmPasswordError;

  String _password = "";

  bool _loading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });

    _confirmPasswordController.addListener(() {
      setState(() {
        var value = _confirmPasswordController.text;
        if (value != _password) {
          _confirmPasswordError = "Password are not equal";
        } else {
          _confirmPasswordError = null;
        }
      });
    });
  }

  Future _resetUserPassword() async {
    if (_confirmPasswordError == null) {
      var resetCode = widget.state.getCode();
      var emailAddress = widget.state.getEmail();
      try {
        setState(() {
          _loading = true;
        });
        await _onboardingService.confirmResetPassword(
          _password,
          emailAddress,
          resetCode,
        );
        widget.next();
        setState(() {
          _loading = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Enter new Password",
            style: TextStyle(
              fontSize: 40,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Provide us with a new password for your account",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: "Password",
              errorText: _passwordError,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _showPassword = !_showPassword;
                  });
                },
                icon: _showPassword
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
            ),
            obscureText: _showPassword,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              errorText: _confirmPasswordError,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
                icon: _showConfirmPassword
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility),
              ),
            ),
            obscureText: _showConfirmPassword,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: _loading ? null : _resetUserPassword,
            child: const Text("Continue"),
          )
        ],
      ),
    );
  }
}
