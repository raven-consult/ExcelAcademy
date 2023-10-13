import "package:flutter/material.dart";

class CourseChapter extends StatelessWidget {
  final bool done;
  final bool locked;
  final String videoUrl;
  final Function(String) onClickVideo;

  const CourseChapter({
    super.key,
    required this.done,
    required this.locked,
    required this.videoUrl,
    required this.onClickVideo,
  });

  @override
  Widget build(BuildContext context) {
    var icon = locked
        ? const Icon(
            Icons.lock,
          )
        : Icon(
            Icons.check_circle,
            color: done ? Colors.green.withGreen(230) : Colors.grey[400],
          );

    return InkWell(
      onTap: () {
        if (locked) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Course locked"),
            ),
          );
        } else {
          onClickVideo(videoUrl);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Playing video"),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 4,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  icon,
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1. Introduction to the course",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color:
                                      locked ? Colors.grey[500] : Colors.black,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            child: Text(
                              "Video: 1hr 30mins",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: locked
                                        ? Colors.grey[500]
                                        : Colors.black,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
              width: double.infinity,
              color: Colors.white,
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              height: 30,
              width: double.infinity,
              color: Colors.white,
            ),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              height: 30,
              width: double.infinity,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
