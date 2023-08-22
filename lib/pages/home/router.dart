import "package:flutter/material.dart";

import "layout.dart";
import "search/search.dart";
import "package:mobile/pages/onboarding/onboarding.dart";

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeRouter extends StatefulWidget {
  final String subRoute;

  const HomeRouter(this.subRoute, {super.key});

  @override
  State<HomeRouter> createState() => _HomeRouter();
}

class _HomeRouter extends State<HomeRouter> {
  void _gotoCart() {
    Navigator.of(context).pushNamed("cart");
  }

  void _gotoNotification() {
    Navigator.of(context).pushNamed("notifications");
  }

  void _gotoSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const Search();
        },
      ),
    );
  }

  void gotoRegister() async {
    await Navigator.of(context).pushNamed(
      "onboarding",
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
      case "":
        page = Main(
          gotoCart: _gotoCart,
          gotoLogin: gotoLogin,
          gotoSearch: _gotoSearch,
          gotoRegister: gotoRegister,
          gotoNotification: _gotoNotification,
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
