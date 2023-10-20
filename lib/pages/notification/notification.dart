import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class notificationUi extends StatelessWidget {
  const notificationUi({super.key});

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
    );
  }
}
