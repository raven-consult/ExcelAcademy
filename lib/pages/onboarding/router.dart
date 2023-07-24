import 'package:flutter/material.dart';

import 'login/login.dart';
import 'welcome/welcome.dart';
import 'setup_account/setup_account.dart';
import 'reset_password/reset_password.dart';
import 'create_account/create_account.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class OnboardingRouter extends StatefulWidget {
  final String subRoute;

  const OnboardingRouter(this.subRoute, {super.key});

  @override
  State<OnboardingRouter> createState() => _OnboardingRouter();
}

class _OnboardingRouter extends State<OnboardingRouter> {
  void _tapOut() {
    Navigator.of(context).pushReplacementNamed("home");
  }

  Route _onGenerateRoute(RouteSettings settings) {
    Widget? page;

    switch (settings.name) {
      case "/":
        page = const Welcome();
        break;
      case "/login":
        page = Login(goHome: _tapOut);
        break;
      case "/setup_account":
        page = SetupAccount(goHome: _tapOut);
        break;
      case "/reset_password":
        page = ResetPassword(goHome: _tapOut);
        break;
      case "/create_account":
        page = CreateAccount(goHome: _tapOut);
        break;
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        return page!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey.currentState != null &&
            navigatorKey.currentState!.canPop()) {
          navigatorKey.currentState!.pop();
          return false;
        }
        return true;
      },
      child: Navigator(
        key: navigatorKey,
        initialRoute: widget.subRoute,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
}
