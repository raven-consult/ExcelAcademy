import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../service.dart';
import 'reset_password.dart';

const Color primaryColor = Color(0xFF121212);
const Color accentPinkColor = Color(0xFFF99BBD);
const Color accentPurpleColor = Color(0xFF6A53A1);
const Color accentYellowColor = Color(0xFFFFB612);
const Color accentOrangeColor = Color(0xFFEA7A3B);
const Color accentDarkGreenColor = Color(0xFF115C49);

class OTPConfirmation extends StatefulWidget {
  final Function next;
  final ResetPasswordState state;

  const OTPConfirmation({super.key, required this.next, required this.state});

  @override
  State<OTPConfirmation> createState() => _OTPConfirmation();
}

class _OTPConfirmation extends State<OTPConfirmation> {
  String _code = "";
  bool _loading = false;

  final _onboardingService = OnboardingService();

  // 2 minutes
  final _timerDuration = 120;
  int _countdownDuration = 120;
  bool _shouldShowResend = false;

  void _verifyOTP() async {
    setState(() {
      _loading = true;
    });
    await _onboardingService.verifyOTP(widget.state.getEmail(), _code);
    widget.state.setCode(_code);
    widget.next();
    setState(() {
      _loading = false;
    });
  }

  String _formatDuration(int period) {
    var seconds = (period % 60).toString().padLeft(2, "0");
    var minutes = (period ~/ 60).toString().padLeft(2, "0");

    return "$minutes:$seconds";
  }

  void _showResendSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Code has been resent"),
      ),
    );
  }

  void _resendOTP() async {
    var email = widget.state.getEmail();
    await _onboardingService.resetPassword(email, resend: true);

    _showResendSnackBar();

    setState(() {
      _shouldShowResend = false;
      _countdownDuration = _timerDuration;
    });
  }

  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownDuration == 0) {
        setState(() {
          _shouldShowResend = true;
        });
        return;
      }
      setState(() {
        _countdownDuration--;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? createStyle() {
      ThemeData theme = Theme.of(context);
      return theme.textTheme.displaySmall;
    }

    final otpTextStyles = [
      createStyle(),
      createStyle(),
      createStyle(),
      createStyle(),
      createStyle(),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Almost There!",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 4.5 * (MediaQuery.of(context).size.width / 6),
                    child: const Text(
                      "Please enter the OTP sent to your email specified",
                      style: TextStyle(
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  OtpTextField(
                    filled: true,
                    numberOfFields: 5,
                    fieldWidth: 62,
                    obscureText: true,
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    margin: const EdgeInsets.only(right: 22),
                    fillColor: const Color(0xFFFFE6D5),
                    borderColor: const Color(0xFFFF822B),
                    focusedBorderColor: const Color(0xFFFF822B),
                    styles: otpTextStyles,
                    showFieldAsBox: false,
                    borderWidth: 4.0,
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) {
                      setState(() {
                        _code = verificationCode;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: _shouldShowResend
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Expires ${_formatDuration(_countdownDuration)}",
                          style: const TextStyle(fontSize: 17),
                        ),
                        _shouldShowResend
                            ? TextButton(
                                onPressed: _resendOTP,
                                child: const Text(
                                  "Resend OTP? Click here",
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _loading ? null : _verifyOTP,
                    child: const Text("Verify OTP"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
