import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:mobile/pages/notification/notification_service.dart';
import 'package:mobile/services/notifications.dart';
import 'package:mobile/theme/typography.dart';
import 'package:intl/intl.dart';

class notificationUi extends StatelessWidget {
  notificationUi({super.key});

  Future<dynamic> _getNotifications() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var userNotifications =
        await NotificationService.getMyNotifications(currentUser!.uid);

    var _totalNotifications = userNotifications.length;

    return _totalNotifications;
  }

  bool checkCount(notification) {
    print('notification');
    if (notification == 0) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 23),
            child: Icon(
              Icons.shopping_bag,
              shadows: [
                Shadow(
                  color: Colors.grey[400]!,
                  blurRadius: 3,
                  offset: const Offset(0, 2.5),
                ),
              ],
              size: 33,
            ),
          ),
        ],
      ),
      body: checkCount(_getNotifications())
          ? _yesNotification()
          : _noNotification(),
    );
  }
}

class _noNotification extends StatelessWidget {
  const _noNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          height: 115,
        ),
        Image.asset('assets/pages/notification/none.png'),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Text(
            'You don’t have any Notifications at the moment',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
        )
      ]),
    );
  }
}

// class _yesNotification extends StatelessWidget {
//   const _yesNotification({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [Text('2')]);
//   }
// }

class _yesNotification extends StatefulWidget {
  const _yesNotification({super.key});

  @override
  State<_yesNotification> createState() => __yesNotificationState();
}

class __yesNotificationState extends State<_yesNotification>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          controller: _tabController,
          unselectedLabelColor: Color(0xff999999),
          labelColor: Color(0xffFF822B),
          indicatorColor: Color(0xffFF822B),
          tabs: const <Widget>[
            Tab(
              text: "Activities",
            ),
            Tab(
              text: "My Account",
            ),
            Tab(
              text: "What's New",
            ),
          ],
        ),
        Flexible(
          child: TabBarView(controller: _tabController, children: [
            Container(
              child: Activities_Widget(),
            ),
            Center(
              child: Account_Widget(),
            ),
            Center(
              child: News_Widget(),
            )
          ]),
        )
      ],
    );
  }
}

class Activities_Widget extends StatelessWidget {
  Activities_Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<NotificationModel>>>(
        future: getNotification().getNotifications(),
        builder: (context, snapshot) {
          final notifications = snapshot.data;
          final activities = notifications?['activities'];

          if (activities == null || activities.isEmpty) {
            return Center(child: Text('...'));
          }
          return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 28, right: 28, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Image.asset('assets/pages/notification/activities.png'),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                activities[index].title,
                                style: textTheme.titleLarge,
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                              Text(DateFormat.EEEE()
                                  .format(activities[index].date.toDate()))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(activities[index].body),
                        ],
                      )
                    ],
                  ),
                );
              });
        });
  }
}

class Account_Widget extends StatelessWidget {
  Account_Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<NotificationModel>>>(
        future: getNotification().getNotifications(),
        builder: (context, snapshot) {
          final notifications = snapshot.data;
          final account = notifications?['account'];

          if (account == null || account.isEmpty) {
            return Center(child: Text('...'));
          }
          return ListView.builder(
              itemCount: account.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 28, right: 28, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Image.asset('assets/pages/notification/account.png'),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                account[index].title,
                                style: textTheme.titleLarge,
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                              Text(DateFormat.EEEE()
                                  .format(account[index].date.toDate()))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(account[index].body),
                        ],
                      )
                    ],
                  ),
                );
              });
        });
  }
}

class News_Widget extends StatelessWidget {
  News_Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<NotificationModel>>>(
        future: getNotification().getNotifications(),
        builder: (context, snapshot) {
          final notifications = snapshot.data;
          final news = notifications?['news'];

          if (news == null || news.isEmpty) {
            return Center(child: Text('...'));
          }
          return ListView.builder(
              itemCount: news.length,
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 28, right: 28, top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Image.asset('assets/pages/notification/new.png'),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                news[index].title,
                                style: textTheme.titleLarge,
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                              Text(DateFormat.EEEE()
                                  .format(news[index].date.toDate()))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(news[index].body),
                        ],
                      )
                    ],
                  ),
                );
              });
        });
  }
}
