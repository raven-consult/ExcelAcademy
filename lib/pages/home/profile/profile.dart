import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

class Profile extends StatelessWidget {
  const Profile({super.key});

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    "https://picsum.photos/200",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Hello World",
                ),
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Hello World",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview() {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star),
                      Text("0"),
                    ],
                  ),
                  const Text("Course Completed"),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.star),
                      Text("0"),
                    ],
                  ),
                  const Text("Course Completed"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            print("Hello");
          },
        ),
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          _buildProfile(),
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: _buildReview(),
          ),
        ],
      ),
    );
  }
}
