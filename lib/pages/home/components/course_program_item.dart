import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

class CourseProgramItemData {
  final int color;
  final String initial;
  final String fullName;
  final String assetUrl;
  final int numOfLevels;
  final int numOfCourses;

  const CourseProgramItemData({
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

String _getURL(String icon) {
  return prefix.replaceFirst("{icon}", icon);
}

final List<CourseProgramItemData> sampleCoursePrograms = [
  CourseProgramItemData(
    initial: "ICAN",
    color: 0xFF0F0BAB,
    fullName: "Institute of Chartered Accountants of Nigeria",
    assetUrl: _getURL("ican_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  ),
  CourseProgramItemData(
    initial: "ACCA",
    color: 0xFFFF822B,
    fullName: "Association of Chartered Certified Accountants",
    assetUrl: _getURL("acca_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  ),
  CourseProgramItemData(
    initial: "CIMA",
    color: 0xFF1FAF73,
    fullName: "Chartered Institute of Management Accountants",
    assetUrl: _getURL("cima_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  ),
  CourseProgramItemData(
    initial: "CITN",
    color: 0xFF9747FF,
    fullName: "Chartered Institute of Taxation of Nigeria",
    assetUrl: _getURL("citn_logo.png"),
    numOfLevels: 6,
    numOfCourses: 23,
  ),
];


class CourseProgramItem extends StatelessWidget {
  final CourseProgramItemData item;

  const CourseProgramItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
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
  }
}
