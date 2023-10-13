import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";

import "package:firebase_auth/firebase_auth.dart";

import "package:mobile/services/notifications.dart";

class Notifications extends StatefulWidget {
  final Function goToCart;

  const Notifications({
    super.key,
    required this.goToCart,
  });

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
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

  Widget _buildNotLoggedIn() {
    return const Center(
      child: Text("You are not logged in"),
    );
  }

  Widget _buildTab(String notificationType, User user) {
    return FutureBuilder(
      future: NotificationService.getMyNotifications(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(snapshot.error.toString()),
              ),
            );
          });
          return const Center(
            child: Text("An Error Occured"),
          );
        } else if (snapshot.data == null) {
          return const Center(
            child: Text("No notifications"),
          );
        } else {
          var data = snapshot.data!.toList();
          data.retainWhere(
              (notification) => notification.type == notificationType);

          if (data.isEmpty) {
            return Center(
              child: Text("No $notificationType notifications"),
            );
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data[index].title),
                subtitle: Text(data[index].body),
                leading: Image.network(data[index].thumbnailUrl),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return _buildNotLoggedIn();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Notifications"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              widget.goToCart();
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                icon: Icon(Icons.notifications),
                text: "Activities",
              ),
              Tab(
                icon: Icon(Icons.notifications_active),
                text: "My Account",
              ),
              Tab(
                icon: Icon(Icons.notifications_none),
                text: "What's New",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                _buildTab(nActivity, user),
                _buildTab(nAccount, user),
                _buildTab(nWhatsNew, user),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
