import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter/foundation.dart";

import "package:firebase_core/firebase_core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:mobile/pages/notification/notification.dart";

import "theme/theme.dart";
import "theme/color.dart";
import "firebase_options.dart";
import "services/notifications.dart";

import "pages/home/home.dart";
import "pages/onboarding/onboarding.dart";
import "pages/course_view/course_view.dart";

Future<bool> isUserSignedIn() async {
  var user = await FirebaseAuth.instance.authStateChanges().first;
  return user != null;
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load environment variables
  await dotenv.load(fileName: ".env");

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

  String initialRoute = "onboarding";
  var isSignedIn = await isUserSignedIn();
  if (isSignedIn) {
    initialRoute = "home";
  }

  runApp(ExcelAcademy(initialRoute: initialRoute));
}

class ExcelAcademy extends StatelessWidget {
  final String initialRoute;

  const ExcelAcademy({
    super.key,
    this.initialRoute = "onboarding",
  });

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    initializeNotifications();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        title: "Excel Academy",
        initialRoute: initialRoute,
        onGenerateRoute: _onGenerateRoute,
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(
              overscroll: false,
            ),
            child: child!,
          );
        },
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case "home":
        page = const Home(subRoute: "");
        break;
      // case "notifications":
      //   page = const CourseView();
      //   break;
      case "notifications":
        page = const notificationUi();
        break;
      case "onboarding":
        if (settings.arguments != null) {
          var options = settings.arguments as OnboardingOptions;
          page = Onboarding(subRoute: options.initialRoute);
        } else {
          page = const Onboarding(subRoute: "/");
        }
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
