import "package:flutter/material.dart";
import "package:flutter/gestures.dart";

import "package:firebase_auth/firebase_auth.dart";
import "package:cached_network_image/cached_network_image.dart";

class UserGreeter extends StatelessWidget {
  final Function onClickLogin;
  final Function onClickRegister;

  const UserGreeter({
    super.key,
    required this.onClickLogin,
    required this.onClickRegister,
  });

  User? get _user => FirebaseAuth.instance.currentUser;

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
                  ..onTap = () async {
                    onClickRegister();
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
                  ..onTap = () async {
                    onClickLogin();
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _userAuthenticated(BuildContext context) {
    var name = _user?.displayName ?? "Simisola";
    var profilePhoto = _user?.photoURL ?? "https://picsum.photos/200";

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
                name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        Container(
          width: 90,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            image: DecorationImage(
              image: CachedNetworkImageProvider(profilePhoto),
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
    if (_user == null) {
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
