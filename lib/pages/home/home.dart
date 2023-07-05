import "package:flutter/material.dart";

import "router.dart";

class Home extends StatefulWidget {
  final String subRoute;

  const Home({super.key, required this.subRoute});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return HomeRouter(widget.subRoute);
  }
}
