import "package:flutter/material.dart";

import '../components/course_program_item.dart';

class CourseProgramsList extends StatelessWidget {
  const CourseProgramsList({super.key});

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
          children: sampleCoursePrograms.map((item) {
            return InkWell(
              onTap: () {
                print("Tapped ${item.fullName}");
              },
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 6,
                ),
                child: CourseProgramItem(item: item),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            print("Hello");
          },
          child: Container(
            height: 50,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: ShapeDecoration(
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
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
        ),
      ],
    );
  }
}
