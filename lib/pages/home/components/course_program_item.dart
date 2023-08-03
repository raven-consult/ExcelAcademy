import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

import "package:mobile/services/available_programs.dart";

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
