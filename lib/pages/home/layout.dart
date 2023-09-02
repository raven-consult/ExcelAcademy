import "package:flutter/material.dart";

import "cart/cart.dart";
import "explore/explore.dart";
import "profile/profile.dart";
import "programs/programs.dart";
import "my_learning/my_learning.dart";

class Main extends StatefulWidget {
  final Function gotoCart;
  final Function gotoLogin;
  final Function gotoSearch;
  final Function gotoRegister;
  final Function gotoNotification;

  const Main({
    super.key,
    required this.gotoCart,
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

  List<Widget> _tabs() => [
        Explore(
          gotoCart: _gotoCart,
          gotoLogin: widget.gotoLogin,
          gotoSearch: widget.gotoSearch,
          gotoCategories: _gotoCategories,
          gotoMyLearning: _gotoMyLearning,
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 5,
      vsync: this,
    );
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
        items: const [
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(Icons.explore),
          ),
          BottomNavigationBarItem(
            label: "Category",
            icon: Icon(Icons.category),
          ),
          BottomNavigationBarItem(
            label: "My Learning",
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Icon(Icons.shopping_cart),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.account_box),
          ),
        ],
      ),
    );
  }

  void _gotoCategories() {
    setState(() {
      _currentIndex = 1;
      _tabController.animateTo(_currentIndex);
    });
  }

  void _gotoCart() {
    setState(() {
      _currentIndex = 3;
      _tabController.animateTo(3);
    });
  }

  void _gotoMyLearning() {
    setState(() {
      _currentIndex = 2;
      _tabController.animateTo(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigation(),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _tabs(),
      ),
    );
  }
}
