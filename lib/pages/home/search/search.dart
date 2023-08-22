import "package:flutter/material.dart";

import "package:avatar_stack/avatar_stack.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:cached_network_image/cached_network_image.dart";

import "../components/courses_group.dart";

const imageUrl = "https://firebasestorage.googleapis.com/v0"
    "/b/excel-academy-online.appspot.com"
    "/o/assets%2Fhomepage%2Fcontinue-learning.png?alt=media";

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _Search();
}

class _Search extends State<Search> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget _buildSearchBar() {
    return TextField(
      autofocus: true,
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
        return Text(
          text,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
        );
      },
    );
  }

  Widget _buildTopSearches() {
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
              _buildText(
                text: "CIS Courses",
                onClick: () {},
              ),
              const SizedBox(height: 8),
              _buildText(
                text: "ACCA Courses",
                onClick: () {},
              ),
              const SizedBox(height: 8),
              _buildText(
                text: "CFA Courses",
                onClick: () {},
              ),
              const SizedBox(height: 8),
              _buildText(
                text: "CIMA Courses",
                onClick: () {},
              ),
              const SizedBox(height: 8),
              _buildText(
                text: "CISI Courses",
                onClick: () {},
              ),
              const SizedBox(height: 8),
              _buildText(
                text: "CIS Courses",
                onClick: () {},
              ),
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

  Widget _buildFeaturedCourses() {
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
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
          return FeaturedVideo(
            courseItem: mockData()[itemIndex],
          );
        },
      ),
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
              _buildTopSearches(),
              const SizedBox(height: 16),
              _buildBrowseByCategories(),
              const SizedBox(height: 16),
              _buildFeaturedCourses(),
            ],
          ),
        ),
      ),
    );
  }
}

class FeaturedVideo extends StatelessWidget {
  final CourseItem courseItem;

  const FeaturedVideo({
    super.key,
    required this.courseItem,
  });

  Widget _buildRating() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                courseItem.rating.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStudentsList() {
    return AvatarStack(
      height: 30,
      avatars: courseItem.students
          .map((e) => CachedNetworkImageProvider(e.photoUrl))
          .toList(),
    );
  }

  Widget _buildText() {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              courseItem.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Icon(
              size: 50,
              color: Colors.white,
              Icons.play_circle_filled,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  courseItem.imageUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 12,
            child: _buildRating(),
          ),
          Positioned(
            top: 8,
            right: 12,
            width: 65,
            child: _buildStudentsList(),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
          ),
          Positioned(
            child: Container(
              height: 65,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: _buildText(),
            ),
          ),
        ],
      ),
    );
  }
}
