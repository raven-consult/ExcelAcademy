import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";

import "package:firebase_auth/firebase_auth.dart";
// import "package:carousel_slider/carousel_slider.dart";

// import "featured_video.dart";
import "package:mobile/utils/grpc.dart";
import "../components/courses_group.dart";
import 'package:mobile/services/course.dart';
import "package:mobile/services/search.dart";

const imageUrl = "https://firebasestorage.googleapis.com/v0"
    "/b/excel-academy-online.appspot.com"
    "/o/assets%2Fhomepage%2Fcontinue-learning.png?alt=media";

class Search extends StatefulWidget {
  final Function gotoCart;

  const Search({
    super.key,
    required this.gotoCart,
  });

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> with AutomaticKeepAliveClientMixin {
  String _queryString = "";

  User? user;
  late TextEditingController _controller;

  // Show query results on screen
  Future<List<Course>>? _queryResults;
  late SearchService _courseSearchService;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    user = FirebaseAuth.instance.currentUser;
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
      controller: _controller,
      onEditingComplete: () {
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
            onPressed: () {
              setState(() {
                _queryString = "";
                _queryResults = null;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildText({required String text, required Function onClick}) {
    return InkWell(
      onTap: () {
        _queryString = text;
        _controller.value = TextEditingValue(text: text);
        FocusScope.of(context).unfocus();
        _getQueryResults();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Icon(
              Icons.arrow_outward,
            ),
          ],
        ),
      ),
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
              FutureBuilder(
                  future: searchesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error"));
                    } else {
                      return ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 7);
                        },
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return _buildText(
                            text: snapshot.data![index],
                            onClick: () {},
                          );
                        },
                      );
                    }
                  }),
            ],
          ),
        );
      },
    );
  }

  /* Widget _buildBrowseByCategories() { */
  /*   return Builder( */
  /*     builder: (BuildContext context) { */
  /*       return Column( */
  /*         crossAxisAlignment: CrossAxisAlignment.start, */
  /*         children: [ */
  /*           Text( */
  /*             "Browse by Categories", */
  /*             style: Theme.of(context) */
  /*                 .textTheme */
  /*                 .titleLarge */
  /*                 ?.copyWith(fontWeight: FontWeight.bold), */
  /*           ), */
  /*           const SizedBox(height: 10), */
  /*           Container( */
  /*             decoration: BoxDecoration( */
  /*               color: Colors.grey[300], */
  /*               borderRadius: BorderRadius.circular(4), */
  /*             ), */
  /*             padding: const EdgeInsets.symmetric( */
  /*               vertical: 12, */
  /*               horizontal: 16, */
  /*             ), */
  /*             child: Row( */
  /*               mainAxisAlignment: MainAxisAlignment.spaceBetween, */
  /*               children: [ */
  /*                 Row( */
  /*                   children: [ */
  /*                     Container( */
  /*                       width: 12, */
  /*                       height: 12, */
  /*                       decoration: ShapeDecoration( */
  /*                         shape: const CircleBorder(), */
  /*                         color: Theme.of(context).colorScheme.primary, */
  /*                       ), */
  /*                     ), */
  /*                     const SizedBox(width: 6), */
  /*                     Text( */
  /*                       "Chartered Institute of Stockbrokers", */
  /*                       style: Theme.of(context).textTheme.titleMedium, */
  /*                     ), */
  /*                   ], */
  /*                 ), */
  /*                 const Icon( */
  /*                   Icons.chevron_right, */
  /*                   size: 24, */
  /*                 ), */
  /*               ], */
  /*             ), */
  /*           ) */
  /*         ], */
  /*       ); */
  /*     }, */
  /*   ); */
  /* } */

  /* Widget _buildFeaturedCourses( */
  /*     {required Future<List<Video>> featuredCoursesFuture}) { */
  /*   return FutureBuilder( */
  /*     future: featuredCoursesFuture, */
  /*     builder: (context, snapshot) { */
  /*       if (snapshot.connectionState == ConnectionState.waiting) { */
  /*         return const SizedBox( */
  /*           height: 195, */
  /*           child: Center(child: CircularProgressIndicator()), */
  /*         ); */
  /*       } else { */
  /*         return SizedBox( */
  /*           height: 195, */
  /*           child: CarouselSlider.builder( */
  /*             itemCount: mockData().length, */
  /*             options: CarouselOptions( */
  /*               height: 400, */
  /*               padEnds: false, */
  /*               initialPage: 0, */
  /*               autoPlay: false, */
  /*               viewportFraction: 0.95, */
  /*               pageSnapping: false, */
  /*               enableInfiniteScroll: false, */
  /*               scrollDirection: Axis.horizontal, */
  /*             ), */
  /*             itemBuilder: */
  /*                 (BuildContext context, int itemIndex, int pageViewIndex) { */
  /*               return FeaturedVideo( */
  /*                 courseItem: mockData()[itemIndex], */
  /*               ); */
  /*             }, */
  /*           ), */
  /*         ); */
  /*       } */
  /*     }, */
  /*   ); */
  /* } */

  @override
  bool get wantKeepAlive => true;

  Widget _buildSearchResultsPage() {
    return FutureBuilder(
      future: _queryResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 195,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(snapshot.error.toString()),
              ),
            );
          });
          return const Center(child: Text("Error"));
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text("No results found"));
        } else {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1 / 1.09,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!
                .map<Widget>(
                  (item) => CourseCard(
                    item: item,
                  ),
                )
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildInitialPage() {
    return Column(
      children: [
        _buildTopSearches(
          searchesFuture: _courseSearchService
              .getPreviousSearches(user != null ? user!.uid : ""),
        ),
        /* const SizedBox(height: 16), */
        /* _buildBrowseByCategories(), */
        /* const SizedBox(height: 16), */
        /* _buildFeaturedCourses( */
        /*   featuredCoursesFuture: _courseSearchService.getFeaturedVideos(), */
        /* ), */
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
          onPressed: () {
            if (_queryResults != null) {
              setState(() {
                _queryResults = null;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              widget.gotoCart();
            },
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
              const SizedBox(height: 12),
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
