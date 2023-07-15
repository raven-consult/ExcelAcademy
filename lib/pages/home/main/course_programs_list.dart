import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

class CourseProgramItem {
  final int color;
  final String initial;
  final String fullName;
  final String assetUrl;
  final int numOfLevels;
  final int numOfCourses;

  const CourseProgramItem({
    required this.color,
    required this.initial,
    required this.fullName,
    required this.assetUrl,
    required this.numOfLevels,
    required this.numOfCourses,
  });
}

const prefix = "https://firebasestorage.googleapis.com/v0"
    "/b/excel-academy-online.appspot.com"
    "/o/assets%2Fpages%2Fhomepage%2Fprograms%2F"
    "{icon}?alt=media";

class CourseProgramsList extends StatelessWidget {
  CourseProgramsList({Key? key}) : super(key: key);

  final List<CourseProgramItem> _coursePrograms = [
    CourseProgramItem(
      initial: "ICAN",
      color: 0xFF0F0BAB,
      fullName: "Institute of Chartered Accountants of Nigeria",
      assetUrl: prefix.replaceFirst("{icon}", "ican_logo.png"),
      numOfLevels: 6,
      numOfCourses: 23,
    ),
    CourseProgramItem(
      initial: "ACCA",
      color: 0xFFFF822B,
      fullName: "Association of Chartered Certified Accountants",
      assetUrl: prefix.replaceFirst("{icon}", "acca_logo.png"),
      numOfLevels: 6,
      numOfCourses: 23,
    ),
    CourseProgramItem(
      initial: "CIMA",
      color: 0xFF1FAF73,
      fullName: "Chartered Institute of Management Accountants",
      assetUrl: prefix.replaceFirst("{icon}", "cima_logo.png"),
      numOfLevels: 6,
      numOfCourses: 23,
    ),
    CourseProgramItem(
      initial: "CITN",
      color: 0xFF9747FF,
      fullName: "Chartered Institute of Taxation of Nigeria",
      assetUrl: prefix.replaceFirst("{icon}", "citn_logo.png"),
      numOfLevels: 6,
      numOfCourses: 23,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Programs",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 2),
            Text(
              "Browse through our available programs",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          physics: const NeverScrollableScrollPhysics(),
          children: _coursePrograms.map((item) {
            return InkWell(
              onTap: () {
                print("Tapped ${item.fullName}");
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 6,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        height: 50,
                        color: const Color(0xFFF3F3F1),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.initial,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Container(
                              height: 70,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    item.assetUrl,
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(
                              item.fullName,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Row(
                              children: [
                                Text("${item.numOfCourses} Courses"),
                                const SizedBox(width: 8),
                                Text("${item.numOfLevels} Levels"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Color(item.color),
                        width: 6,
                        height: 160,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.grey[300],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "See more courses",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(Icons.arrow_forward),
            ],
          ),
        ),
      ],
    );
  }
}
