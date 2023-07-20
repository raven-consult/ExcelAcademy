import "package:flutter/material.dart";

import "search.dart";
import "popular.dart";
import "nav_cart.dart";
import "ad_panel.dart";
import "user_greeter.dart";
import "ongoing_course.dart";
import "course_programs_list.dart";

class Explore extends StatefulWidget {
  final Function gotoCart;
  final Function gotoLogin;
  final Function gotoRegister;
  final Function gotoNotification;

  const Explore({
    super.key,
    required this.gotoCart,
    required this.gotoLogin,
    required this.gotoRegister,
    required this.gotoNotification,
  });

  @override
  State<Explore> createState() => _Explore();
}

class _Explore extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          children: [
            UserGreeter(
              onClickLogin: widget.gotoLogin,
              onClickRegister: widget.gotoRegister,
            ),
            const SizedBox(height: 8),
            NavCart(
              goToCart: widget.gotoCart,
              goToNotifications: widget.gotoNotification,
            ),
            const SizedBox(height: 24),
            const Search(),
            const SizedBox(height: 24),
            const AdPanel(),
            const SizedBox(height: 24),
            CourseProgramsList(),
            const SizedBox(height: 24),
            const OngoingCourse(
              progress: 50,
              courseName:
                  "ICAN Public Sector Accounting and Finance (Revision)",
            ),
            const SizedBox(height: 24),
            const PopularCourses(),
            const SizedBox(height: 24),
            const PopularCourses(),
          ],
        ),
      ),
    );
  }
}
