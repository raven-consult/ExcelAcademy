import 'package:flutter/material.dart';

class HomeTabsController {
  final TabController _tabController;

  const HomeTabsController(this._tabController);

  void gotoExplore() {
    _tabController.animateTo(0);
  }

  void gotoPrograms() {
    _tabController.animateTo(1);
  }

  void gotoMyLearning() {
    _tabController.animateTo(2);
  }

  void gotoCart() {
    _tabController.animateTo(3);
  }

  void gotoProfile() {
    _tabController.animateTo(4);
  }

  void gotoLogin() {
    _tabController.animateTo(0);
  }
}
