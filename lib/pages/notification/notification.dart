import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile/theme/typography.dart';

class notificationUi extends StatelessWidget {
  notificationUi({super.key});
  int count = 0;
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
    return Center(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: 115,
        ),
        Image.asset('assets/pages/notification/none.png'),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Text(
            'You don’t have any Notifications at the moment',
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
        )
      ]),
    );
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
