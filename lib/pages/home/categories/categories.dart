import "package:flutter/material.dart";

import '../components/course_program_item.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  Widget _buildSearchBar() {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Find in Categories",
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                suffixIcon: SizedBox(
                  width: 75,
                  child: TextButton(
                    onPressed: () {
                      print("Search");
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: const Text("Search"),
                  ),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            width: 75,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, size: 30),
              onPressed: () {
                print("Search");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      elevation: Theme.of(context).appBarTheme.elevation,
      centerTitle: Theme.of(context).appBarTheme.centerTitle,
      toolbarHeight: Theme.of(context).appBarTheme.toolbarHeight ?? 70,
      foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          print("Hello");
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            print("Shopping");
          },
        ),
      ],
      title: const Text("Categories"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            _buildAppBar(context),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _buildSearchBar(),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ...sampleCoursePrograms,
                    ...sampleCoursePrograms,
                    ...sampleCoursePrograms,
                  ]
                      .map(
                        (item) => CourseProgramItem(
                          item: item,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
