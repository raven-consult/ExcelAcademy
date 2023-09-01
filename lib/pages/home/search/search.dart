import "package:flutter/material.dart";

import "package:carousel_slider/carousel_slider.dart";

import "package:mobile/utils/grpc.dart";
import "../components/courses_group.dart";
import 'package:mobile/services/course.dart';
import "package:mobile/services/search.dart";

import "course_item.dart";
import "featured_video.dart";

const imageUrl = "https://firebasestorage.googleapis.com/v0"
    "/b/excel-academy-online.appspot.com"
    "/o/assets%2Fhomepage%2Fcontinue-learning.png?alt=media";

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> with AutomaticKeepAliveClientMixin {
  String _queryString = "";


  // Show query results on screen
  Future<List<Course>>? _queryResults;
  late SearchService _courseSearchService;

  @override
  void initState() {
    super.initState();
    _courseSearchService = SearchService(
      searchServiceConn["host"] as String,
      searchServiceConn["port"] as String,
      getGRPCCallOptions(),
    );
  }

  Future<void> _getQueryResults() async {
    try {
      setState(() {
        _queryResults = _courseSearchService.query(_queryString);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildSearchBar() {
    return TextField(
      autofocus: true,
      onEditingComplete: () {
        print(_queryString);
        FocusScope.of(context).unfocus();
        _getQueryResults();
      },
      onChanged: (value) {
        print("Value: $value");
        _queryString = value;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.grey,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        border: const OutlineInputBorder(),
        hintText: "Search",
        suffixIcon: SizedBox(
          width: 70,
          child: TextButton(
            child: const Text("Clear"),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildText({required String text, required Function onClick}) {
    return Builder(
      builder: (BuildContext context) {
        return Column(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildTopSearches({required Future<List<String>> searchesFuture}) {
    return Builder(
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Top Searches by courses",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              FutureBuilder(
                  future: searchesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error"));
                    } else {
                      return Column(
                        children: [
                          ...snapshot.data!
                              .map((item) =>
                                  _buildText(text: item, onClick: () {}))
                              .toList(),
                        ],
                      );
                    }
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBrowseByCategories() {
    return Builder(
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Browse by Categories",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: ShapeDecoration(
                          shape: const CircleBorder(),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Chartered Institute of Stockbrokers",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 24,
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildFeaturedCourses(
      {required Future<List<Video>> featuredCoursesFuture}) {
    return FutureBuilder(
      future: featuredCoursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 195,
            child: Center(child: CircularProgressIndicator()),
          );
        } else {
          return SizedBox(
            height: 195,
            child: CarouselSlider.builder(
              itemCount: mockData().length,
              options: CarouselOptions(
                height: 400,
                padEnds: false,
                initialPage: 0,
                autoPlay: false,
                viewportFraction: 0.95,
                pageSnapping: false,
                enableInfiniteScroll: false,
                scrollDirection: Axis.horizontal,
              ),
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return FeaturedVideo(
                  courseItem: mockData()[itemIndex],
                );
              },
            ),
          );
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildSearchResultsPage() {
    return FutureBuilder(
      future: _queryResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error"));
          /* } else if (snapshot.hasData && snapshot.data!.isEmpty) { */
          /*   return const Center(child: Text("No results found")); */
        } else {
          return Column(
            children: mockData()
                .map((item) => SearchResultItem(course: item))
                .toList(),
          );
          /* return Column( */
          /*   children: [ */
          /*     ...snapshot.data! */
          /*         .map((item) => SearchResultItem(course: item)) */
          /*         .toList(), */
          /*   ], */
          /* ); */
        }
      },
    );
  }

  Widget _buildInitialPage() {
    return Column(
      children: [
        _buildTopSearches(
          searchesFuture: _courseSearchService.getPopularSearches(),
        ),
        const SizedBox(height: 16),
        _buildBrowseByCategories(),
        const SizedBox(height: 16),
        _buildFeaturedCourses(
          featuredCoursesFuture: _courseSearchService.getFeaturedVideos(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Column(
            children: [
              Hero(
                tag: "search",
                child: Material(
                  child: _buildSearchBar(),
                ),
              ),
              const SizedBox(height: 24),
              _queryResults == null
                  ? _buildInitialPage()
                  : _buildSearchResultsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
