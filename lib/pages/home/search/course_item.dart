import "package:flutter/material.dart";

import "../components/courses_group.dart";

class SearchResultItem extends StatelessWidget {
  final CourseItem course;

  const SearchResultItem({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 8,
        ),
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(course.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Description of the course",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
            /* Flexible( */
            /*   child: SizedBox( */
            /*     width: double.infinity, */
            /*     child: Column( */
            /*       mainAxisAlignment: MainAxisAlignment.center, */
            /*       children: [ */
            /*         Text( */
            /*           course.rating.toString(), */
            /*           style: Theme.of(context).textTheme.titleLarge, */
            /*         ), */
            /*         const SizedBox(height: 4), */
            /*         Text( */
            /*           course.rating.toString(), */
            /*           style: Theme.of(context).textTheme.titleLarge, */
            /*         ), */
            /*       ], */
            /*     ), */
            /*   ), */
            /* ), */
          ],
        ),
      ),
    );
  }
}
