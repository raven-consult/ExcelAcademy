import "package:flutter/material.dart";

import "package:circular_chart_flutter/circular_chart_flutter.dart";

import "package:mobile/components/shimmer.dart";
import "package:mobile/services/user_library.dart";

class MyLearning extends StatefulWidget {
  const MyLearning({super.key});

  @override
  State<MyLearning> createState() => _MyLearning();
}

class _MyLearning extends State<MyLearning>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  final List<GlobalKey<AnimatedCircularChartState>> _chartKey = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    ); // initialIndex: 0
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          print("Hello");
        },
      ),
      centerTitle: false,
      title: const Text("My Learning"),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      labelStyle: Theme.of(context).textTheme.labelLarge,
      labelColor: Colors.black,
      indicator: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      controller: _tabController,
      tabs: const [
        Tab(
          text: "Ongoing",
        ),
        Tab(
          text: "Completed",
        ),
        Tab(
          text: "Bookmarks",
        ),
      ],
    );
  }

  Widget _buildLoadingCourseItem() {
    var key = GlobalKey<AnimatedCircularChartState>();
    _chartKey.add(key);
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: ShimmerWidget.rectangular(
                height: 100,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    ShimmerWidget.rectangular(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ShimmerWidget.rectangular(
                      height: 20,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          print("Retake Exam");
                        },
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: ShimmerWidget.rectangular(
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          print("Start Challenge");
                        },
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: ShimmerWidget.rectangular(
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: ShimmerWidget.circular(
                height: 70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseItem(
    UserCourse userCourse,
  ) {
    var course = userCourse.course;
    var key = GlobalKey<AnimatedCircularChartState>();
    _chartKey.add(key);
    return Container(
      height: 125,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 4,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            flex: 1,
            child: FlutterLogo(
              size: 70,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  course.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "${course.duration.inHours.toString()} hrs "
                  "${(course.duration.inMinutes % 60).toString()} mins",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 4,
                      child: InkWell(
                        onTap: () {
                          print("Retake Exam");
                        },
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            "Retake Exam",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                    Flexible(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          print("Start Challenge");
                        },
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            "Start Challenge",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: AnimatedCircularChart(
              key: key,
              size: const Size(80, 80),
              initialChartData: [
                CircularStackEntry(
                  <CircularSegmentEntry>[
                    CircularSegmentEntry(
                      75,
                      Theme.of(context).colorScheme.primary,
                      rankKey: "completed",
                    ),
                    CircularSegmentEntry(
                      25,
                      Colors.grey.shade300,
                      rankKey: "remaining",
                    ),
                  ],
                  rankKey: "progress",
                ),
              ],
              chartType: CircularChartType.Radial,
              percentageValues: true,
              holeLabel: "75%",
              labelStyle: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Cleanup
  /* Widget _buildBookmarkedCourseItem() { */
  /*   return Container( */
  /*     height: 125, */
  /*     padding: const EdgeInsets.symmetric( */
  /*       vertical: 8, */
  /*     ), */
  /*     decoration: ShapeDecoration( */
  /*       shape: RoundedRectangleBorder( */
  /*         borderRadius: BorderRadius.circular(8), */
  /*         side: BorderSide( */
  /*           color: Colors.grey.shade300, */
  /*           width: 1.5, */
  /*         ), */
  /*       ), */
  /*       color: Colors.white, */
  /*     ), */
  /*     margin: const EdgeInsets.symmetric( */
  /*       horizontal: 4, */
  /*       vertical: 4, */
  /*     ), */
  /*     child: Row( */
  /*       crossAxisAlignment: CrossAxisAlignment.start, */
  /*       children: [ */
  /*         const Expanded( */
  /*           flex: 2, */
  /*           child: FlutterLogo( */
  /*             size: 70, */
  /*           ), */
  /*         ), */
  /*         Expanded( */
  /*           flex: 4, */
  /*           child: Column( */
  /*             crossAxisAlignment: CrossAxisAlignment.start, */
  /*             children: [ */
  /*               Text( */
  /*                 "Strategic Financial Management", */
  /*                 style: Theme.of(context).textTheme.titleLarge, */
  /*               ), */
  /*               const SizedBox( */
  /*                 height: 6, */
  /*               ), */
  /*               Text( */
  /*                 "2hrs 30mins", */
  /*                 style: Theme.of(context).textTheme.titleMedium, */
  /*               ), */
  /*             ], */
  /*           ), */
  /*         ), */
  /*         Expanded( */
  /*           flex: 1, */
  /*           child: Container( */
  /*             padding: const EdgeInsets.all(8), */
  /*             child: const Icon(Icons.bookmark_border), */
  /*           ), */
  /*         ), */
  /*       ], */
  /*     ), */
  /*   ); */
  /* } */

  Widget _buildTabBarLayout(Future<List<UserCourse>> itemsFuture) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      child: FutureBuilder(
        future: itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              itemCount: 10,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 4,
                );
              },
              itemBuilder: (context, index) {
                return _buildLoadingCourseItem();
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No Data Found",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 4,
                );
              },
              itemBuilder: (context, index) {
                return _buildCourseItem(snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildLayout(
    Future<List<UserCourse>> ongoingCourse,
    Future<List<UserCourse>> completedCourse,
    Future<List<UserCourse>> bookmarkedCourse,
  ) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTabBarLayout(ongoingCourse),
        _buildTabBarLayout(completedCourse),
        _buildTabBarLayout(bookmarkedCourse),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var future = Future.delayed(const Duration(seconds: 5), () {
      return <UserCourse>[];
    });

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildLayout(
              future,
              future,
              future,
            ),
          ),
        ],
      ),
    );
  }
}
