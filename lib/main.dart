import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/foundation.dart";

import "package:firebase_core/firebase_core.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";

import "theme/theme.dart";
import "theme/color.dart";
import "firebase_options.dart";

import "pages/home/home.dart";
import "pages/cart/cart.dart";
import "pages/onboarding/onboarding.dart";
import "pages/notifications/notifications.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  const weWantFatalErrorRecording = bool.fromEnvironment(
    "FLUTTER_CRASHLYTICS_FATAL",
    defaultValue: false,
  );

  FlutterError.onError = (errorDetails) {
    if (weWantFatalErrorRecording) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    } else {
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (kDebugMode) {
    // Disable Crashlytics collection while doing every day development.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  FirebaseFirestore.instance.settings = FirebaseFirestore.instance.settings
      .copyWith(ignoreUndefinedProperties: false);

  runApp(const ExcelAcademy());
}

class ExcelAcademy extends StatelessWidget {
  const ExcelAcademy({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: colorScheme.surface,
        /* statusBarColor: Colors.transparent, //top status bar */
        /* statusBarIconBrightness: Brightness.dark, // status bar icons' color */
        /* systemNavigationBarIconBrightness: */
        /*     Brightness.dark, //navigation bar icons' color */
      ),
      child: MaterialApp(
        theme: theme,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              overscroll: false,
            ),
            child: child!,
          );
        },
        darkTheme: darkTheme,
        title: "Excel Academy",
        onGenerateRoute: _onGenerateRoute,
        home: const Onboarding(subRoute: "/"),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case "/home":
        page = const Home(subRoute: "/");
        break;
      case "/onboarding":
        if (settings.arguments != null) {
          var options = settings.arguments as OnboardingOptions;
          page = Onboarding(subRoute: options.initialRoute);
        } else {
          page = const Onboarding(subRoute: "/");
        }
        break;
      case "/cart":
        page = const Cart();
        break;
      case "/notifications":
        page = const NotificationsPage();
        break;
    }

    return MaterialPageRoute(
      settings: settings,
      builder: (context) {
        return page;
      },
    );
  }
}
