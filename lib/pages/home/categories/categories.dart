import "package:flutter/material.dart";

import '../components/course_program_item.dart';

import "package:mobile/components/shimmer.dart";
import "package:mobile/services/available_programs.dart";

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _Categories();
}

class _Categories extends State<Categories> with AutomaticKeepAliveClientMixin {
  final ProgramsService _programsService = ProgramsService();

  late Future<List<CourseProgramItemData>> _programs;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _programs = _programsService.getAllPrograms();
  }

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
    super.build(context);

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
                FutureBuilder(
                  future: _programs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(
                          4,
                          (index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 6,
                              ),
                              child: ShimmerWidget.rectangular(),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error"),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No data"),
                      );
                    } else {
                      var snapshotData = snapshot.data!;
                      return GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ...snapshotData,
                          ...snapshotData,
                          ...snapshotData,
                        ].map((item) {
                          return CourseProgramItem(item: item);
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
