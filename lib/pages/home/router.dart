import "package:flutter/material.dart";

import "main/main.dart";

import "package:mobile/pages/onboarding/onboarding.dart";

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeRouter extends StatefulWidget {
  final String subRoute;

  const HomeRouter(this.subRoute, {super.key});

  @override
  State<HomeRouter> createState() => _HomeRouter();
}

class _HomeRouter extends State<HomeRouter> {
  /* void _tapOut() { */
  /*   Navigator.of(context).pushReplacementNamed("/home"); */
  /* } */

  void gotoRegister() async {
    await Navigator.of(context).pushNamed(
      "/onboarding",
      arguments: const OnboardingOptions(
        initialRoute: "/create_account",
      ),
    );
  }

  void gotoLogin() async {
    await Navigator.of(context).pushNamed(
      "/onboarding",
      arguments: const OnboardingOptions(
        initialRoute: "/login",
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    Widget? page;

    switch (settings.name) {
      case "/":
        page = Main(
          gotoLogin: gotoLogin,
          gotoRegister: gotoRegister,
        );
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
