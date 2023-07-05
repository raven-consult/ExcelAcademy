import "dart:ui";
import "dart:async";

import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";

import "theme/theme.dart";
import "firebase_options.dart";

import "pages/home/home.dart";
import "pages/onboarding/onboarding.dart";

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

  runApp(const ExcelAcademy());
}

class ExcelAcademy extends StatelessWidget {
  const ExcelAcademy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      darkTheme: darkTheme,
      title: "Excel Academy",
      onGenerateRoute: _onGenerateRoute,
      home: const Onboarding(subRoute: "/"),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case "/home":
        page = const Home(subRoute: "/");
        break;
      case "/onboarding":
        page = const Onboarding(subRoute: "/");
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
