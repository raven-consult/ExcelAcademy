import "dart:async";

import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";

import "package:mobile/services/user.dart";
import "package:mobile/services/course.dart";

// import "pricing.dart";
// import "reviews.dart";
import "course_title.dart";
import "video_player.dart";
import "course_chapter.dart";

class CourseView extends StatefulWidget {
  const CourseView({super.key});

  @override
  State<CourseView> createState() => _CourseView();
}

const imageUrl = "https://firebasestorage.googleapis.com/v0"
    "/b/excel-academy-online.appspot.com"
    "/o/assets%2Fhomepage%2Fcontinue-learning.png?alt=media";

class _CourseView extends State<CourseView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late PlatformUser _user;
  final Course course = Course.fromMap({
    "id": "flutter",
    "title": "Flutter",
    "description": "Learn Flutter",
    "price": 234.4,
    "thumbnailUrl": imageUrl,
    "rating": 4.5,
    "videos": [],
    "students": [],
    "reviews": [],
  });

  Timer? timer;
  int _timeout = 0;
  String? _currentVideoUrl;

  Future<void> _getCurrentUser() async {
    var fUser = FirebaseAuth.instance.currentUser;
    if (fUser != null) {
      print("No current user");
      final user = await PlatformUser.getUser(fUser.uid);
      setState(() {
        _user = user;
      });
    } else {
      print("No current user");
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  final defaultVideo =
      "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";

  void _changeVideo(String videoUrl) {
    setState(() {
      _currentVideoUrl = videoUrl;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _resetTimeout() {
    setState(() {
      _timeout = 3;
      if (timer != null) timer!.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeout > 0) {
          setState(() {
            _timeout--;
          });
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _onVisibilityChanged() {
    _resetTimeout();
  }

  Widget _buildVideoPlayer() {
    return VideoPlayer(
      onClickPrev: () {
        print("Previous video");
      },
      onClickNext: () {
        print("Next video");
      },
      videoType: VideoType.network,
      url: _currentVideoUrl ?? defaultVideo,
      onVisibilityChanged: _onVisibilityChanged,
    );
  }

  Widget _buildCourseTitle() {
    var impression =
        _user.courseImpressions[course.id] ?? CourseImpression.none;

    return CourseTitle(
      title: course.title,
      impression: impression,
      onImpressionChanged: (impression) async {
        await _user.updateCourseImpression(course.id, impression);
      },
    );
  }

  Widget _buildMoreChapters() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      child: Text(
        "Load more chapters",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildCourseChapters() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Course Videos",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          CourseChapter(
            done: true,
            locked: false,
            videoUrl: defaultVideo,
            onClickVideo: _changeVideo,
          ),
          CourseChapter(
            done: false,
            locked: false,
            videoUrl: defaultVideo,
            onClickVideo: _changeVideo,
          ),
          CourseChapter(
            done: false,
            locked: true,
            videoUrl: defaultVideo,
            onClickVideo: _changeVideo,
          ),
          CourseChapter(
            done: false,
            locked: true,
            videoUrl: defaultVideo,
            onClickVideo: _changeVideo,
          ),
          _buildMoreChapters(),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildReviews() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                width: 65,
                height: 28,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("See all"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // const Review(),
        ],
      ),
    );
  }

  Widget _buildCourseDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Course Description",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            "KickStart or accelerate your career as an Advanced Audit and Assurance personnel"
            "from this revision course tailored to bring the best in you."
            "The detailed study notes, standard questions and answers, and past questions trend,"
            "also serve as important course materials necessary to broaden your understanding of"
            "the course.",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  print("Add to cart");
                },
                child: const Text("Add to Cart"),
              ),
              TextButton(
                onPressed: () {
                  print("Buy now");
                },
                child: const Text("Buy Now"),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildVideoPlayer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCourseTitle(),
                        const SizedBox(height: 2),
                        _buildCourseDescription(),
                        const SizedBox(height: 8),
                        // _buildReviews(),
                        /* const SizedBox(height: 8), */
                        /* const Pricing(), */
                        const SizedBox(height: 8),
                        _buildCourseChapters(),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 12,
                left: 12,
                child: AnimatedOpacity(
                  opacity: _timeout == 0 ? 0 : 1,
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      size: 32,
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
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
