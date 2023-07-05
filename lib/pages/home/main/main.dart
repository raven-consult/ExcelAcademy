import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";
import "package:mobile/pages/home/main/course_programs.dart";

import "search.dart";
import "nav_cart.dart";
import "ad_panel.dart";
import "user_greeter.dart";

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    final user = true
        ? MockUser(
            displayName: "John Doe",
            email: "example@gmail.com",
            photoURL: "https://example.com/johndoe.jpg",
          )
        : null;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            children: [
              UserGreeter(user: user),
              const SizedBox(height: 16),
              const NavCart(),
              const SizedBox(height: 16),
              const Search(),
              const SizedBox(height: 16),
              const AdPanel(),
              const SizedBox(height: 16),
              const CoursePrograms(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
