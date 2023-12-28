import "package:flutter/material.dart";
import "package:flutter_speed_dial/flutter_speed_dial.dart";
import "package:mobile/pages/community/ui/community_home.dart";

import 'package:provider/provider.dart';
import "package:firebase_auth/firebase_auth.dart";

import "package:mobile/services/cart.dart";

import "cart/cart.dart";
import "explore/explore.dart";
import "profile/profile.dart";
import "programs/programs.dart";
import "home_tabs_navigator.dart";
import "my_learning/my_learning.dart";

class Main extends StatefulWidget {
  final Function gotoLogin;
  final Function gotoSearch;
  final Function gotoRegister;
  final Function gotoNotification;

  const Main({
    super.key,
    required this.gotoLogin,
    required this.gotoSearch,
    required this.gotoRegister,
    required this.gotoNotification,
  });

  @override
  State<Main> createState() => _Main();
}

class _Main extends State<Main> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  int _cartItems = 0;

  List<Widget> _tabs() => [
        Explore(
          gotoLogin: widget.gotoLogin,
          gotoSearch: widget.gotoSearch,
          gotoRegister: widget.gotoRegister,
          gotoNotification: widget.gotoNotification,
        ),
        const Programs(),
        const MyLearning(),
        const Cart(),
        Profile(
          goToRegister: widget.gotoRegister,
        ),
      ];

  Future<void> getUserCart() async {
    /* Future.delayed( */
    /*   const Duration(seconds: 4), */
    /*   () async { */
    /*     setState(() { */
    /*       _cartItems = 3; */
    /*     }); */
    /*   }, */
    /* ); */
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var cartUser = await CartUser.getUser(user.uid);
      var cartItems = await cartUser.getCartItems();
      setState(() {
        _cartItems = cartItems.length;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserCart();

    _tabController = TabController(
      length: 5,
      vsync: this,
    );

    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  Widget _bottomNavigation() {
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        enableFeedback: true,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            _tabController.animateTo(index);
          });
        },
        items: [
          const BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(Icons.explore),
          ),
          const BottomNavigationBarItem(
            label: "Programs",
            icon: Icon(Icons.category),
          ),
          const BottomNavigationBarItem(
            label: "My Learning",
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Badge.count(
              count: _cartItems,
              textColor: Colors.white,
              backgroundColor: Colors.red,
              isLabelVisible: _cartItems > 0,
              child: const Icon(Icons.shopping_cart),
            ),
          ),
          const BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_box),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provider<HomeTabsController>(
      create: (_) => HomeTabsController(_tabController),
      child: Scaffold(
        bottomNavigationBar: _bottomNavigation(),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: _tabs(),
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.add_event,
          backgroundColor: const Color(0xffD0D1D2),
          iconTheme: const IconThemeData(color: Color(0xff323232)),
          children: [
            SpeedDialChild(
              label: 'Community Groups',
              child: Icon(Icons.people),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CommunityHomeUi()),
                );
              },
            ),
            SpeedDialChild(
                label: 'Chat with the admin', child: Icon(Icons.chat))
          ],
        ),
      ),
    );
  }
}
