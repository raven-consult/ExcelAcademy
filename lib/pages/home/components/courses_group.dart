import "package:flutter/material.dart";

import "package:cached_network_image/cached_network_image.dart";

import "package:mobile/services/course.dart";

class CoursesGroup extends StatelessWidget {
  final String title;
  final String description;
  final Future<List<Course>> courseItems;

  const CoursesGroup({
    super.key,
    required this.title,
    required this.description,
    required this.courseItems,
  });

  List<Widget> _buildList(List<Course> courseItems) {
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
          FutureBuilder(
            future: courseItems,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("No data"),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildList(snapshot.data!),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course item;

  const CourseCard({
    super.key,
    required this.item,
  });

  void _onClick(BuildContext context) {
    Navigator.of(context).pushNamed(
      "course_view",
      arguments: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onClick(context),
      child: Container(
        width: 265,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Material(
          elevation: 1,
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
                    image: CachedNetworkImageProvider(item.thumbnailUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
                    Row(
                      children: [
                        const Icon(
                          Icons.group,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${item.students.length.round()} students",
                        ),
                      ],
                    ),
                    /* item.students.isNotEmpty */
                    /*     ? FutureBuilder( */
                    /*         future: */
                    /*             Future.wait(item.students.map((student) async { */
                    /*           var user = await PlatformUser.getUser(student); */
                    /*           return CachedNetworkImageProvider(user.photoUrl); */
                    /*         }).toList()), */
                    /*         builder: */
                    /*             (BuildContext context, AsyncSnapshot snapshot) { */
                    /*           if (snapshot.connectionState == */
                    /*               ConnectionState.waiting) { */
                    /*             return const Text("0"); */
                    /*           } else if (snapshot.hasError) { */
                    /*             print(snapshot.error); */
                    /*             return const Text("0"); */
                    /*           } else { */
                    /*             return Flexible( */
                    /*               flex: 1, */
                    /*               child: AvatarStack( */
                    /*                 height: 30, */
                    /*                 avatars: snapshot.data, */
                    /*               ), */
                    /*             ); */
                    /*           } */
                    /*         }, */
                    /*       ) */
                    /*     : Container(), */
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 8, right: 8),
                child: Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                        ),
                        Text(item.price.toString()),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Row(
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
                  ],
                ),
              ),
            ],
          ),
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

List<Course> mockData() {
  return const [
    Course(
      id: "2",
      title: "Flutter Course",
      description: "This is a course about Flutter",
      price: 100,
      rating: 4.5,
      reviews: [],
      thumbnailUrl: "https://picsum.photos/206",
      students: [],
      videos: [],
    ),
    Course(
      id: "3",
      title: "React Course",
      description: "This is a course about React",
      price: 100,
      rating: 4.5,
      reviews: [],
      thumbnailUrl: "https://picsum.photos/207",
      students: [],
      videos: [],
    ),
    Course(
      id: "4",
      title: "Vue Course",
      description: "This is a course about Vue",
      price: 100,
      rating: 4.5,
      reviews: [],
      thumbnailUrl: "https://picsum.photos/208",
      students: [],
      videos: [],
    ),
    Course(
      id: "5",
      title: "Angular Course",
      description: "This is a course about Angular",
      price: 100,
      rating: 4.5,
      reviews: [],
      thumbnailUrl: "https://picsum.photos/209",
      students: [],
      videos: [],
    ),
    Course(
      id: "6",
      title: "Dart Course",
      description: "This is a course about Dart",
      price: 100,
      rating: 4.5,
      reviews: [],
      thumbnailUrl: "https://picsum.photos/210",
      students: [],
      videos: [],
    ),
  ];
}
