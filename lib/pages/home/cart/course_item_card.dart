import "package:flutter/material.dart";

import "package:money_formatter/money_formatter.dart";

class CourseItem extends StatelessWidget {
  final String title;
  final double price;
  final String program;

  const CourseItem({
    super.key,
    required this.title,
    required this.price,
    required this.program,
  });

  Widget _thumbnailPicture() {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: const FlutterLogoDecoration(
        style: FlutterLogoStyle.horizontal,
      ),
    );
  }

  Widget _buildCourseInfo() {
    var price = MoneyFormatter(
      amount: this.price,
    );

    return Builder(
      builder: (BuildContext context) => Container(
        color: Colors.grey[300],
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Program: $program",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  "₦${price.output.nonSymbol}",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Tapped on $title");
      },
      child: Material(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _thumbnailPicture(),
              _buildCourseInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
