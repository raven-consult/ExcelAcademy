import "package:flutter/material.dart";

class CourseProgramsList extends StatelessWidget {
  const CourseProgramsList({Key? key}) : super(key: key);

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
          children: List.generate(4, (index) {
            return Container(
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
                            "ICAN",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const FlutterLogo(size: 70),
                          Text(
                            "Institute of Chartered Accountants of Nigeria",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: const [
                              Text("23 Courses"),
                              SizedBox(width: 8),
                              Text("6 Levels"),
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
                      color: Colors.green[300],
                      width: 6,
                      height: 160,
                    ),
                  ),
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
