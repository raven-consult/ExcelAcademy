import "dart:math" as math;

import "package:flutter/material.dart";

class OngoingCourse extends StatelessWidget {
  final int progress;
  final String courseName;

  const OngoingCourse({
    super.key,
    required this.progress,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 24;
    return InkWell(
      splashColor: Colors.blue,
      splashFactory: InkSplash.splashFactory,
      onTap: () {
        print("Ongoing course tapped");
      },
      child: SizedBox(
        height: 175,
        child: Stack(
          clipBehavior: Clip.antiAlias,
          children: [
            Positioned(
              bottom: 0,
              width: width,
              height: 175,
              child: Transform.rotate(
                angle: -math.pi * 0.025,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              height: 175,
              width: width,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.30),
                      BlendMode.dstATop,
                    ),
                    image: const AssetImage(
                      "assets/pages/homepage/ongoing_course_background.png",
                    ),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ongoing course",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      courseName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Stack(
                            children: [
                              Container(
                                height: 6,
                                width: MediaQuery.of(context).size.width - 131,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                width:
                                    ((MediaQuery.of(context).size.width - 132) *
                                            progress /
                                            100)
                                        .abs(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "$progress% of 100%",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Continue learning",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 24,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
