import "package:flutter/material.dart";
import 'package:carousel_slider/carousel_slider.dart';

class OngoingCourse extends StatefulWidget {
  final Function gotoMyLearning;

  const OngoingCourse({
    super.key,
    required this.gotoMyLearning,
  });

  @override
  State<OngoingCourse> createState() => _OngoingCourse();
}

class _OngoingCourse extends State<OngoingCourse> {
  final int progress = 50;
  final String courseName =
      "ICAN Public Sector Accounting and Finance (Revision)";

  Widget _buildCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                        width: ((MediaQuery.of(context).size.width - 132) *
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.blue,
      splashFactory: InkSplash.splashFactory,
      onTap: () {
        widget.gotoMyLearning();
      },
      child: SizedBox(
        height: 175,
        child: CarouselSlider.builder(
          itemCount: 6,
          options: CarouselOptions(
            height: 400,
            initialPage: 0,
            autoPlay: false,
            viewportFraction: 0.95,
            enableInfiniteScroll: false,
            scrollDirection: Axis.horizontal,
          ),
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            return _buildCard();
          },
        ),
      ),
    );
  }
}
