import "package:flutter/material.dart";

import "package:provider/provider.dart";
import "package:firebase_auth/firebase_auth.dart";

import "../home_tabs_navigator.dart";
import "package:mobile/services/cart.dart";

import "empty_cart.dart";
import "course_items.dart";

class Cart extends StatefulWidget {
  const Cart({
    super.key,
  });

  @override
  State<Cart> createState() => _Cart();
}

class _Cart extends State<Cart> {
  // List all open source projects made by google, store it as a list of strings
  /* List<CartItem> _cartItems = []; */

  final _cartItems = [
    "Flutter",
    "TensorFlow",
    "Kubernetes",
    "Dart",
    "Skia",
    "Angular",
    "Go",
    "Bazel",
    "Chromium",
    "Dagger",
    "Firebase",
    "Flutter",
  ];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    /* var currentUser = FirebaseAuth.instance.currentUser; */
    /* if (currentUser != null) { */
    /*   var cartUser = await CartUser.getUser(currentUser.uid); */
    /*   setState(() { */
    /*     _cartItems = cartUser.cartItems; */
    /*   }); */
    /* } */
  }

  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: false,
      title: const Text("Cart"),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        child: _cartItems.isEmpty
            ? EmptyCart(
                gotoPrograms: context.read<HomeTabsController>().gotoPrograms,
              )
            : CourseItems(
                cartItems: _cartItems,
              ),
      ),
    );
  }
}
