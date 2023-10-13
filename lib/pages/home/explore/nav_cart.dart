import "dart:async";

import "package:flutter/material.dart";

import "package:firebase_auth/firebase_auth.dart";

import "package:mobile/services/cart.dart";
import "package:mobile/components/shimmer.dart";
import "package:mobile/services/notification.dart";

class NavCart extends StatefulWidget {
  final Function goToCart;
  final Function goToNotifications;

  const NavCart({
    super.key,
    required this.goToCart,
    required this.goToNotifications,
  });

  @override
  State<NavCart> createState() => _NavCart();
}

class _NavCart extends State<NavCart> {
  bool _loading = false;
  late int _totalCartItems;
  late int _totalNotifications;

  @override
  void initState() {
    super.initState();
    _totalCartItems = 0;
    _totalNotifications = 0;
    _loading = true;

    Future.wait([
      _getCartItems(),
      _getNotifications(),
    ]).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<void> _getCartItems() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var cartUser = await CartUser.getUser(currentUser!.uid);
    var cartItems = await cartUser.getCartItems();
    setState(() {
      _totalCartItems = cartItems.length;
    });
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> _getNotifications() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    var notificationService = NotificationService(currentUser!.uid);
    var userNotifications = await notificationService.getAllNotifications();
    setState(() {
      _totalNotifications = userNotifications.length;
    });
    await Future.delayed(const Duration(seconds: 2));
  }

  String _formatMessage() {
    if (_totalNotifications == 0 && _totalCartItems == 0) {
      return "No new notifications";
    } else {
      return "You have $_totalNotifications notifications and $_totalCartItems cart items";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return ShimmerWidget.rectangular(
        height: 53,
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_formatMessage()),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  widget.goToNotifications();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Badge(
                    isLabelVisible: _totalNotifications > 0,
                    child: Icon(
                      Icons.notifications_on,
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
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  widget.goToCart();
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Badge(
                    isLabelVisible: _totalCartItems > 0,
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
