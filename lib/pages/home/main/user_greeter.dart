import "package:flutter/material.dart";
import "package:flutter/gestures.dart";

import "package:firebase_auth/firebase_auth.dart";

class UserGreeter extends StatelessWidget {
  final User? user;

  const UserGreeter({
    super.key,
    required this.user,
  });

  Widget _userNotAuthenticated(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Welcome There!",
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
              ),
        ),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  wordSpacing: 5,
                ),
            children: [
              TextSpan(
                text: "Register",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print("Hello World");
                  },
              ),
              const TextSpan(
                text: " or ",
              ),
              TextSpan(
                text: "Login",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.primary,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    print("Hello World");
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userAuthenticated(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Welcome There,",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                "Simisola",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Container(
          width: 90,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
              image: AssetImage("assets/logo/logo.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        /* AspectRatio( */
        /*   aspectRatio: 1, */
        /*   child: Image.asset( */
        /*     "assets/logo/logo.png", */
        /*     fit: BoxFit.cover, */
        /*   ), */
        /* ), */
      ],
    );
  }

  Widget _buildUserGreeter(BuildContext context) {
    if (user == null) {
      return _userNotAuthenticated(context);
    } else {
      return _userAuthenticated(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: _buildUserGreeter(context),
    );
  }
}
