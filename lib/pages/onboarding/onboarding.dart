import 'package:flutter/material.dart';
import 'package:mobile/pages/onboarding/router.dart';

class Onboarding extends StatefulWidget {
  final String subRoute;

  const Onboarding({super.key, required this.subRoute});

  @override
  State<Onboarding> createState() => _Onboarding();
}

class _Onboarding extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return OnboardingRouter(widget.subRoute);
  }
}
