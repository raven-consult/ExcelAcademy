import "package:flutter/material.dart";

class CoursePrograms extends StatelessWidget {
  const CoursePrograms({Key? key}) : super(key: key);

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
          childAspectRatio: 1.5,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(10, (index) {
            return Container(
              height: 50,
              color: Colors.red,
              margin: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 4,
              ),
              child: Column(
                children: const [
                  Text("Hello World"),
                  Text("Hello World"),
                ],
              ),
            );
          }),
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
