import "package:flutter/material.dart";
import "package:mobile/pages/community/ui/community_home.dart";

import "package:provider/provider.dart";

import "../home_tabs_navigator.dart";
import "package:mobile/utils/grpc.dart";
import "../components/courses_group.dart";
import "package:mobile/services/recommendations.dart";

import "search.dart";
import "nav_cart.dart";
import "ad_panel.dart";
import "user_greeter.dart";
import "ongoing_course.dart";
import "course_programs_list.dart";

class Explore extends StatefulWidget {
  final Function gotoLogin;
  final Function gotoSearch;
  final Function gotoRegister;
  final Function gotoNotification;

  const Explore({
    super.key,
    required this.gotoLogin,
    required this.gotoSearch,
    required this.gotoRegister,
    required this.gotoNotification,
  });

  @override
  State<Explore> createState() => _Explore();
}

class _Explore extends State<Explore> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final recommendationService = RecommendationService(
    recommendationsServiceConn["host"]!,
    recommendationsServiceConn["port"]!,
    getGRPCCallOptions(),
  );

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
              goToNotifications: widget.gotoNotification,
              goToCart: context.read<HomeTabsController>().gotoCart,
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            Search(
              gotoSearch: widget.gotoSearch,
            ),
            const SizedBox(height: 24),
            const AdPanel(),
            const SizedBox(height: 24),
            CourseProgramsList(
              gotoPrograms: context.read<HomeTabsController>().gotoPrograms,
            ),
            const SizedBox(height: 24),
            OngoingCourse(
              gotoMyLearning: context.read<HomeTabsController>().gotoMyLearning,
            ),
            const SizedBox(height: 24),
            CoursesGroup(
              title: "Popular Courses",
              description: "Most popular courses",
              courseItems: recommendationService.getPopularCourses(),
            ),
            const SizedBox(height: 8),
            CoursesGroup(
              title: "Latest Courses",
              description: "Newly added courses",
              courseItems: recommendationService.getLatestCourses(),
            ),
          ],
        ),
      ),
    );
  }
}
