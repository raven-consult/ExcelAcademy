import "package:flutter/material.dart";
import "package:firebase_auth_mocks/firebase_auth_mocks.dart";

import "search.dart";
import "popular.dart";
import "nav_cart.dart";
import "ad_panel.dart";
import "user_greeter.dart";
import "ongoing_course.dart";
import "course_programs_list.dart";

class Main extends StatelessWidget {
  const Main({super.key});

  Widget _bottomNavigation() {
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(Icons.explore),
          ),
          BottomNavigationBarItem(
            label: "Category",
            icon: Icon(Icons.category),
          ),
          BottomNavigationBarItem(
            label: "My board",
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_box),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = true
        ? MockUser(
            displayName: "John Doe",
            email: "example@gmail.com",
            photoURL: "https://example.com/johndoe.jpg",
          )
        // ignore: dead_code
        : null;

    return Scaffold(
      bottomNavigationBar: _bottomNavigation(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              UserGreeter(user: user),
              const SizedBox(height: 8),
              const NavCart(),
              const SizedBox(height: 24),
              const Search(),
              const SizedBox(height: 24),
              const AdPanel(),
              const SizedBox(height: 24),
              const CourseProgramsList(),
              const SizedBox(height: 24),
              const OngoingCourse(),
              const SizedBox(height: 24),
              const PopularCourses(),
              const SizedBox(height: 24),
              const PopularCourses(),
            ],
          ),
        ),
      ),
    );
  }
}