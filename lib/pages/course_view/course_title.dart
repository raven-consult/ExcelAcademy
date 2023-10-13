import "package:flutter/material.dart";
import "package:mobile/services/user.dart";

class CourseTitle extends StatefulWidget {
  final String title;
  final CourseImpression impression;
  final Function(CourseImpression) onImpressionChanged;

  const CourseTitle({
    super.key,
    required this.title,
    required this.impression,
    required this.onImpressionChanged,
  });

  @override
  State<CourseTitle> createState() => _CourseTitle();
}

class _CourseTitle extends State<CourseTitle> {
  CourseImpression _impression = CourseImpression.none;

  @override
  void initState() {
    super.initState();
    _impression = widget.impression;
  }

  Widget _buildActivities() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            widget.onImpressionChanged(CourseImpression.like);
            setState(() {
              _impression = CourseImpression.like;
            });
          },
          child: Icon(
            _impression == CourseImpression.like
                ? Icons.thumb_up
                : Icons.thumb_up_outlined,
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () {
            widget.onImpressionChanged(CourseImpression.dislike);
            setState(() {
              _impression = CourseImpression.dislike;
            });
          },
          child: Icon(
            _impression == CourseImpression.dislike
                ? Icons.thumb_down
                : Icons.thumb_down_outlined,
            size: 30,
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () {
            print("Share");
          },
          child: const Icon(
            Icons.share_outlined,
            size: 30,
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildExtra() {
    return PopupMenuButton(
      onSelected: (value) {
        print(value);
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: "report",
          child: Text("Report"),
        ),
        PopupMenuItem(
          value: "wishlist",
          child: Text("Add to wishlist"),
        ),
      ],
      child: const Icon(
        Icons.more_vert_outlined,
        size: 30,
      ),
    );
  }

  Widget _buildTitle() {
    return Builder(
      builder: (context) => Text(
        widget.title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildActivities(),
              const Spacer(flex: 4),
              // _buildExtra(),
            ],
          ),
        ],
      ),
    );
  }
}
