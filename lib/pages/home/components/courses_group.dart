import "package:flutter/material.dart";

import "package:avatar_stack/avatar_stack.dart";
import "package:cached_network_image/cached_network_image.dart";

import "package:mobile/services/user.dart";

class CoursesGroup extends StatelessWidget {
  final String title;
  final String description;
  final List<CourseItem> courseItems;

  const CoursesGroup({
    super.key,
    required this.title,
    required this.description,
    required this.courseItems,
  });

  List<Widget> _buildList(BuildContext context) {
    var items = courseItems.map((item) => CourseCard(item: item));

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
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              InkWell(
                onTap: () {
                  print("Hello World");
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 4,
                    left: 8,
                    bottom: 4,
                  ),
                  child: Text(
                    "See more",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.63,
            child: Text(
              description,
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
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final CourseItem item;

  const CourseCard({
    super.key,
    required this.item,
  });

  void _onClick() {
    print("Hello World");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onClick,
      child: Container(
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
            item.subtitle != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    color: Colors.grey[100],
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
                          .map((e) => CachedNetworkImageProvider(e.photoUrl))
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
      ),
    );
  }
}

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

List<CourseItem> mockData() {
  return const [
    CourseItem(
      id: "2",
      title: "Flutter Course",
      rating: 4.5,
      imageUrl: "https://picsum.photos/206",
      subtitle: englishSubtitle,
      students: [
        PlatformUser(
          uid: "1",
          displayName: "John Doe",
          photoUrl: "https://picsum.photos/207",
        ),
        PlatformUser(
          uid: "2",
          displayName: "John Doe",
          photoUrl: "https://picsum.photos/208",
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
          uid: "3",
          displayName: "John Doe",
          photoUrl: "https://picsum.photos/201",
        ),
        PlatformUser(
          uid: "4",
          displayName: "John Doe",
          photoUrl: "https://picsum.photos/200",
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
          uid: "5",
          displayName: "John Doe",
          photoUrl: "https://picsum.photos/202",
        ),
        PlatformUser(
          uid: "6",
          displayName: "John Doe",
          photoUrl: "https://picsum.photos/203",
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
          uid: "7",
          displayName: "John Doe",
          photoUrl: "https://picsum.photos/202",
        ),
        PlatformUser(
          uid: "8",
          displayName: "John Doe",
          photoUrl: "https://picsum.photos/203",
        ),
      ],
    ),
  ];
}
