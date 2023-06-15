import 'package:flutter/material.dart';

import 'form.dart';
import 'success.dart';
import 'new_password.dart';
import 'otp_confirmation.dart';

class ResetPassword extends StatefulWidget {
  final Function goHome;
  const ResetPassword({super.key, required this.goHome});

  @override
  State<ResetPassword> createState() => _ResetPassword();
}

typedef StepBuilder = Widget Function(Function, Function, ResetPasswordState);

class ResetPasswordState {
  String _code = "";
  String _email = "";

  void setEmail(String email) {
    _email = email;
  }

  void setCode(String code) {
    _code = code;
  }

  String getCode() {
    return _code;
  }

  String getEmail() {
    return _email;
  }
}

class _ResetPassword extends State<ResetPassword> {
  int _currentStep = 0;

  final _state = ResetPasswordState();

  final List<StepBuilder> _steps = [
    (prev, next, state) => PasswordResetForm(next: next, state: state),
    (prev, next, state) => OTPConfirmation(next: next, state: state),
    (prev, next, state) => NewPasswordForm(next: next, state: state),
    (prev, next, state) => Success(next: next),
  ];

  void prev() {
    if (_currentStep != 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void next() {
    if (_currentStep == _steps.length - 1) {
      widget.goHome();
    } else {
      setState(() {
        _currentStep++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text(
          "FORGOT PASSWORD",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: _steps[_currentStep](prev, next, _state),
    );
  }
}
