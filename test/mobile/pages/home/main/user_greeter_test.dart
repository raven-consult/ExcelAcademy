// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import "package:flutter_test/flutter_test.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";

import "package:mobile/pages/home/main/user_greeter.dart";

void main() {
  group("UserGreeter", () {
    testWidgets("When user is not signed in, show login and signup",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const UserGreeter(user: null),
      );

      expect(find.text("Login"), findsOneWidget);
    });

    testWidgets("When user is signed in, show login and signup",
        (WidgetTester tester) async {
      final user = MockUser(
        isAnonymous: false,
        uid: "someuid",
        email: "bob@somedomain.com",
        displayName: "Someone",
      );
      await tester.pumpWidget(
        UserGreeter(user: user),
      );

      expect(find.text("Someone"), findsOneWidget);
    });
  });
}
