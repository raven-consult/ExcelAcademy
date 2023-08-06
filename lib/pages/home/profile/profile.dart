import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";
import "package:cached_network_image/cached_network_image.dart";
import "package:mobile/components/shimmer.dart";

import "payments.dart";
import "achievements.dart";
import "manage_profile.dart";
import "support_and_faq.dart";
import "terms_of_service.dart";

class Profile extends StatefulWidget {
  final Function goToRegister;

  const Profile({
    super.key,
    required this.goToRegister,
  });

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> with AutomaticKeepAliveClientMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late User _user;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
  }

  Widget _buildListTile({
    VoidCallback? onTap,
    required String title,
    required IconData icon,
    required Color iconColor,
    required String subtitle,
    required Color iconBackground,
    Widget Function(BuildContext)? navigationBuilder,
  }) {
    return InkWell(
      onTap: onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: navigationBuilder!,
              ),
            );
          },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: iconBackground,
              child: Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
            ),
            title: Text(title),
            subtitle: Text(subtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildProfile({
    required String name,
    required String profileImage,
  }) {
    var firstName = name.split(" ")[0];
    var lastName = name.split(" ")[1];

    return Container(
      height: 135,
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    profileImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  lastName,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReview({
    required Future<int> achievements,
    required Future<int> coursesCompleted,
  }) {
    Widget buildReviewItem({
      required int value,
      required String name,
      required IconData icon,
    }) {
      return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                const SizedBox(width: 4),
                Text(value.toString()),
              ],
            ),
            Text(
              name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      );
    }

    return FutureBuilder(
      future: Future.wait([
        coursesCompleted,
        achievements,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 70,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShimmerWidget.rectangular(height: 20, width: 30),
                            const SizedBox(width: 6),
                            ShimmerWidget.rectangular(height: 20, width: 30),
                          ],
                        ),
                        ShimmerWidget.rectangular(
                          height: 15,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShimmerWidget.rectangular(height: 20, width: 30),
                            const SizedBox(width: 6),
                            ShimmerWidget.rectangular(height: 20, width: 30),
                          ],
                        ),
                        ShimmerWidget.rectangular(
                          height: 15,
                          width: 100,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: buildReviewItem(
                    value: 0,
                    name: "Courses Completed",
                    icon: Icons.topic_outlined,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: buildReviewItem(
                    value: 0,
                    name: "Achievements",
                    icon: Icons.emoji_events_outlined,
                  ),
                ),
              ],
            ),
          );
        } else {
          var coursesCompleted = snapshot.data![0];
          var achievements = snapshot.data![1];
          return SizedBox(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: buildReviewItem(
                    value: coursesCompleted,
                    name: "Courses Completed",
                    icon: Icons.topic_outlined,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: buildReviewItem(
                    value: achievements,
                    name: "Achievements",
                    icon: Icons.emoji_events_outlined,
                  ),
                ),
              ],
            ),
          );
        }
      },
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
        centerTitle: false,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfile(
              name: _user.displayName!,
              profileImage: _user.photoURL!,
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: Text(
                      "Quick Review",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: _buildReview(
                // TODO: Implement achievements service
                achievements: Future.delayed(
                  const Duration(seconds: 3),
                  () => 0,
                ),
                // TODO: Implement courses completed service
                coursesCompleted: Future.delayed(
                  const Duration(seconds: 3),
                  () => 0,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Divider(
                thickness: 1.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildListTile(
                    title: "Achievements",
                    subtitle: "Tournament wins, Certifications, etc",
                    icon: Icons.emoji_events,
                    iconColor: Colors.orange[600]!,
                    iconBackground: Colors.orange[100]!,
                    navigationBuilder: (context) => const Achievements(),
                  ),
                  _buildListTile(
                    title: "Manage Profile",
                    subtitle: "Change your personal details",
                    icon: Icons.person,
                    iconColor: Colors.green[600]!,
                    iconBackground: Colors.green[100]!,
                    navigationBuilder: (context) => const ManageProfile(),
                  ),
                  _buildListTile(
                    title: "Payments",
                    subtitle: "Configure your notification settings",
                    icon: Icons.payment,
                    iconColor: Colors.cyan[600]!,
                    iconBackground: Colors.cyan[100]!,
                    navigationBuilder: (context) => const Payments(),
                  ),
                  _buildListTile(
                    title: "Terms of Service",
                    subtitle: "Read our policies and terms of service",
                    icon: Icons.business_center,
                    iconColor: Colors.lightGreen[600]!,
                    iconBackground: Colors.lightGreen[100]!,
                    navigationBuilder: (context) => const TermsOfService(),
                  ),
                  _buildListTile(
                    title: "Support and FAQ",
                    subtitle: "Get help from our support team",
                    icon: Icons.support,
                    iconColor: Colors.brown[600]!,
                    iconBackground: Colors.brown[100]!,
                    navigationBuilder: (context) => const SupportAndFAQ(),
                  ),
                  _buildListTile(
                    title: "Logout",
                    subtitle: "Logout of your account",
                    icon: Icons.logout,
                    iconColor: Colors.red[600]!,
                    iconBackground: Colors.red[100]!,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      widget.goToRegister();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
