import "dart:math" as math;

import "package:flutter/material.dart";

class OngoingCourse extends StatelessWidget {
  const OngoingCourse({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - 24;
    return InkWell(
      splashColor: Colors.blue,
      splashFactory: InkSplash.splashFactory,
      onTap: () {
        print("Ongoing course");
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
                    color: Colors.grey[200],
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
                      "ICAN Public Sector Accounting and Finance (Revision)",
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
                                height: 4,
                                width: MediaQuery.of(context).size.width - 3,
                                color: Colors.blue,
                              ),
                              Container(
                                height: 4,
                                width: ((MediaQuery.of(context).size.width *
                                            0.23) -
                                        132)
                                    .abs(),
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("23% of 100%"),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Continue learning",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Icon(Icons.chevron_right),
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
