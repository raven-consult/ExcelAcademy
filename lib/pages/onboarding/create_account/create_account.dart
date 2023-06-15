import 'package:flutter/material.dart';

import "../service.dart";

class CreateAccount extends StatefulWidget {
  final Function goHome;
  const CreateAccount({super.key, required this.goHome});

  @override
  State<CreateAccount> createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
  final _loginService = OnboardingService();

  String text = "Hello";

  void _gotoCreateAccount(BuildContext context) {
    Navigator.of(context).pushNamed(
      "/setup_account",
      arguments: {
        "email_verified": false,
      },
    );
  }

  void _gotoLogin(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }

  Future _loginWithGoogle() async {
    await _loginService.signInWithGoogle();
    widget.goHome();
  }

  Future _loginWithMicrosoft() async {
    await _loginService.signInWithMicrosoft();
    widget.goHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/pages/onboarding/login_hero.png",
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Warm up to exciting courses. Stay connected",
                      style: TextStyle(fontSize: 30),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _gotoCreateAccount(context);
                              },
                              child: const Text("Create free account"),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              onPressed: _loginWithGoogle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/pages/onboarding/google.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Continue with Google"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(55),
                              ),
                              onPressed: _loginWithMicrosoft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/pages/onboarding/microsoft.png",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text("Continue with Microsoft"),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: const Size.fromHeight(50),
                              ),
                              onPressed: () {
                                _gotoLogin(context);
                              },
                              child: const Text(
                                "Already have an account? Sign In",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
