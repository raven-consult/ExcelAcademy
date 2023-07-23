import "package:flutter/material.dart";
import "package:circular_chart_flutter/circular_chart_flutter.dart";

class MyLearning extends StatefulWidget {
  const MyLearning({super.key});

  @override
  State<MyLearning> createState() => _MyLearning();
}

class _MyLearning extends State<MyLearning> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<GlobalKey<AnimatedCircularChartState>> _chartKey = [];

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
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            print("Search");
          },
        ),
      ],
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

  Widget _buildCourseItem() {
    var key = GlobalKey<AnimatedCircularChartState>();
    _chartKey.add(GlobalKey<AnimatedCircularChartState>());
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
                  "Strategic Financial Management",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  "2hrs 30mins",
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

  Widget _buildBookmarkedCourseItem() {
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
            flex: 2,
            child: FlutterLogo(
              size: 70,
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Strategic Financial Management",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  "2hrs 30mins",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.bookmark_border),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayout() {
    return TabBarView(
      controller: _tabController,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 4,
              );
            },
            itemBuilder: (context, index) {
              return _buildCourseItem();
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 4,
              );
            },
            itemBuilder: (context, index) {
              return _buildCourseItem();
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 4,
              );
            },
            itemBuilder: (context, index) {
              return _buildBookmarkedCourseItem();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildLayout(),
          ),
        ],
      ),
    );
  }
}
