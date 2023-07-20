import "package:flutter/material.dart";

import "package:avatar_stack/avatar_stack.dart";
import "package:cached_network_image/cached_network_image.dart";

import "package:mobile/services/user.dart";

class Subtitle {
  final String id;
  final String title;
  final String imageUrl;

  const Subtitle({
    required this.id,
    required this.title,
    required this.imageUrl,
  });
}

const englishSubtitle = Subtitle(
  id: "1",
  title: "English Subtitle",
  imageUrl: "https://picsum.photos/300",
);

class CourseItem {
  final String id;
  final String title;
  final double rating;
  final String imageUrl;
  final Subtitle? subtitle;
  final List<PlatformUser> students;

  const CourseItem({
    required this.id,
    required this.title,
    required this.rating,
    required this.imageUrl,
    required this.students,
    required this.subtitle,
  });
}

// "https://i.pravatar.cc/150?img=$n

List<CourseItem> _mockData() {
  return [
    CourseItem(
      id: "2",
      title: "Flutter Course",
      rating: 4.5,
      imageUrl: "https://picsum.photos/206",
      subtitle: englishSubtitle,
      students: [
        PlatformUser(
          username: "John Doe",
          gender: Gender.male,
          profilePicture: "https://picsum.photos/207",
          dateOfBirth: DateTime.now(),
        ),
        PlatformUser(
          username: "John Doe",
          gender: Gender.male,
          profilePicture: "https://picsum.photos/208",
          dateOfBirth: DateTime.now(),
        ),
      ],
    ),
    CourseItem(
      id: "2",
      title: "Flutter Course",
      rating: 4.5,
      imageUrl: "https://picsum.photos/205",
      subtitle: englishSubtitle,
      students: [
        PlatformUser(
          username: "John Doe",
          gender: Gender.male,
          profilePicture: "https://picsum.photos/201",
          dateOfBirth: DateTime.now(),
        ),
        PlatformUser(
          username: "John Doe",
          gender: Gender.male,
          profilePicture: "https://picsum.photos/200",
          dateOfBirth: DateTime.now(),
        ),
      ],
    ),
    CourseItem(
      id: "3",
      title: "Flutter Course",
      rating: 4.1,
      imageUrl: "https://picsum.photos/204",
      subtitle: null,
      students: [
        PlatformUser(
          username: "John Doe",
          gender: Gender.male,
          profilePicture: "https://picsum.photos/202",
          dateOfBirth: DateTime.now(),
        ),
        PlatformUser(
          username: "John Doe",
          gender: Gender.male,
          profilePicture: "https://picsum.photos/203",
          dateOfBirth: DateTime.now(),
        ),
      ],
    ),
    CourseItem(
      id: "3",
      title: "Flutter Course",
      rating: 4.5,
      imageUrl: "https://picsum.photos/204",
      subtitle: null,
      students: [
        PlatformUser(
          username: "John Doe",
          gender: Gender.male,
          profilePicture: "https://picsum.photos/202",
          dateOfBirth: DateTime.now(),
        ),
        PlatformUser(
          username: "John Doe",
          gender: Gender.male,
          profilePicture: "https://picsum.photos/203",
          dateOfBirth: DateTime.now(),
        ),
      ],
    ),
  ];
}

class PopularCourses extends StatelessWidget {
  const PopularCourses({super.key});

  Widget _buildCourseCard(BuildContext context, CourseItem item) {
    return Container(
      height: 230,
      width: 265,
      margin: const EdgeInsets.only(right: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              image: DecorationImage(
                image: CachedNetworkImageProvider(item.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 4),
          item.subtitle != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: CachedNetworkImageProvider(
                          item.subtitle!.imageUrl,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item.subtitle!.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )
              : const SizedBox(height: 0),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      print("Pressed");
                    },
                    child: Text(
                      "Add to Cart",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: AvatarStack(
                    height: 30,
                    avatars: item.students
                        .map((e) => NetworkImage(e.profilePicture))
                        .toList(),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Text(
                        item.rating.toString(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildList(BuildContext context) {
    var items = _mockData().map((item) => _buildCourseCard(context, item));

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

    if (cache != null) {
      res.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            cache,
            Visibility(
              visible: false,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: cache,
            ),
          ],
        ),
      );
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular Courses",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                "See more",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.63,
            child: Text(
              "Hello World, From NodeJS Guys "
              "Hello World, From NodeJS",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    height: 1.2,
                    letterSpacing: 0.5,
                  ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildList(context),
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
