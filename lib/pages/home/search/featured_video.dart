import "package:flutter/material.dart";

import "package:avatar_stack/avatar_stack.dart";
import "package:cached_network_image/cached_network_image.dart";

import "package:mobile/services/user.dart";
import "package:mobile/services/course.dart";

class FeaturedVideo extends StatelessWidget {
  final Course courseItem;

  const FeaturedVideo({
    super.key,
    required this.courseItem,
  });

  Widget _buildRating() {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                courseItem.rating.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStudentsList() {
    var users = courseItem.students.map((e) async {
      var user = await PlatformUser.getUser(e);
      return user;
    }).toList();
    return FutureBuilder(
      future: Future.wait(users),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AvatarStack(
            height: 30,
            avatars: snapshot.data!.map((e) {
              return CachedNetworkImageProvider(e.photoUrl);
            }).toList(),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildText() {
    return Builder(
      builder: (BuildContext context) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              courseItem.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Icon(
              size: 50,
              color: Colors.white,
              Icons.play_circle_filled,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  courseItem.thumbnailUrl,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 12,
            child: _buildRating(),
          ),
          Positioned(
            top: 8,
            right: 12,
            width: 65,
            child: _buildStudentsList(),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(1),
                ],
              ),
            ),
          ),
          Positioned(
            child: Container(
              height: 65,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: _buildText(),
            ),
          ),
        ],
      ),
    );
  }
}
