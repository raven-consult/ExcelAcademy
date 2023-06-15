import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  final Function next;
  const Success({super.key, required this.next});

  void _completeResetPassword() {
    next();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const FlutterLogo(size: 200),
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/pages/onboarding/reset_password/confetti.png",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  "Congratulations",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Your account have been restored successfully, we urge you to keep it safe",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _completeResetPassword,
                    child: const Text("Go back to Log in"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
