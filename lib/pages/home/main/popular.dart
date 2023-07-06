import 'package:flutter/material.dart';

class PopularCourses extends StatelessWidget {
  const PopularCourses({super.key});

  Widget _buildCourseItem() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: Colors.white,
        /* borderRadius: BorderRadius.only( */
        /*   topLeft: Radius.circular(10), */
        /*   topRight: Radius.circular(10), */
        /* ), */
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
            width: double.infinity,
            child: FlutterLogo(
              style: FlutterLogoStyle.horizontal,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: const [
              FlutterLogo(size: 25),
              SizedBox(width: 4),
              Text("English Subtitle"),
            ],
          ),
          const SizedBox(height: 4),
          const Text("Course Name"),
        ],
      ),
    );
  }

  Widget _buildCourseCard() {
    return Container(
      height: 200,
      width: 230,
      margin: const EdgeInsets.only(right: 10),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
            ),
            child: const FlutterLogo(),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Course Name",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Course Description",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildList() {
    var items = List.generate(20, (index) => _buildCourseCard());

    List<Widget> res = [];

    Widget? cache;
    for (var item in items) {
      if (cache != null) {
        res.add(
          Column(
            children: [
              cache,
              item,
            ],
          ),
        );
        cache = null;
      } else {
        cache = item;
      }
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Popular Courses",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "See all",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildList(),
            ),
          )
          /* SingleChildScrollView( */
          /*   scrollDirection: Axis.horizontal, */
          /*   child: GridView.count( */
          /*     crossAxisCount: 2, */
          /*     childAspectRatio: 0.7, */
          /*     physics: const NeverScrollableScrollPhysics(), */
          /*     children: List.generate(4, (index) => _buildCourseItem()), */
          /*   ), */
          /* ), */
        ],
      ),
    );
  }
}
