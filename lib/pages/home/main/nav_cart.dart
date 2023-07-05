import "package:flutter/material.dart";

class NavCart extends StatelessWidget {
  const NavCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("You have 2 Notifications and 4 cart items"),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: const Badge(
                  isLabelVisible: true,
                  child: Icon(
                    Icons.notifications_on,
                    size: 30,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: const Badge(
                  isLabelVisible: true,
                  child: Icon(
                    Icons.shopping_bag,
                    size: 30,
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
