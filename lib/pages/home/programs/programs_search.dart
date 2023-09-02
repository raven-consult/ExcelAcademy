import "package:flutter/material.dart";

import "package:mobile/services/course.dart";
import "package:mobile/components/shimmer.dart";

class ProgramSearch extends StatelessWidget {
  final Future<List<Course>> courses;

  const ProgramSearch({
    super.key,
    required this.courses,
  });

  Widget _buildCourse(Course course) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          key: Key(course.id),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: course.thumbnailUrl != ""
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(course.thumbnailUrl),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const FlutterLogoDecoration(
                        style: FlutterLogoStyle.horizontal,
                      ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      course.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                print("Course");
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 4,
                                ),
                                child: Text(
                                  "Add to cart",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 2),
                            const Text("4.5"),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.7,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        5,
        (index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 6,
            ),
            child: ShimmerWidget.rectangular(),
          );
        },
      ),
    );
  }

  Widget _buildProgramCourses() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 0.957,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(
        5,
        (index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 6,
            ),
            child: _buildCourse(
              const Course(
                id: "1",
                videos: [],
                reviews: [],
                rating: 4.5,
                students: [],
                price: 400.0,
                title: "Course",
                thumbnailUrl: "",
                description: "Description",
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildProgramCourses();
  }
}
