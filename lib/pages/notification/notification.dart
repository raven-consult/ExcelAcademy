import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class notificationUi extends StatelessWidget {
  notificationUi({super.key});
  int count = 1;
  bool checkCount(int count) {
    if (count == 0) {
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
      body: checkCount(count) ? _yesNotification() : _noNotification(),
    );
  }
}

class _noNotification extends StatelessWidget {
  const _noNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('1')]);
  }
}

class _yesNotification extends StatelessWidget {
  const _yesNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [Text('2')]);
  }
}
