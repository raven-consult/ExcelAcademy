import "package:flutter/material.dart";

import "package:mobile/services/course.dart";

class SearchResultItem extends StatelessWidget {
  final Course course;

  const SearchResultItem({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.all(8),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(course.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 1),
                              Text(
                                course.rating.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(width: 1),
                          Text(
                            " * ",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(width: 1),
                          Row(
                            children: [
                              Text(
                                "40+ Registered",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
