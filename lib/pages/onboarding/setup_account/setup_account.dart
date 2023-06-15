import 'package:flutter/material.dart';

import 'user_setup.dart';
import 'phone_setup.dart';

class SetupAccount extends StatefulWidget {
  final Function goHome;
  const SetupAccount({super.key, required this.goHome});

  @override
  State<SetupAccount> createState() => _SetupAccount();
}

typedef Callback = Widget Function(
    Function prev, Function next, Function goHome, Function restart);

class _SetupAccount extends State<SetupAccount> {
  int _index = 0;

  final List<Callback> _widgets = [
    (prev, next, goHome, restart) => UserSetup(
          prev: prev,
          next: next,
        ),
    (prev, next, goHome, restart) => PhoneSetup(
          prev: prev,
          next: next,
          goHome: goHome,
        ),
  ];

  void _restart() {
    setState(() {
      _index = 0;
    });
  }

  void _prev() {
    setState(() {
      _index -= 1;
    });
  }

  void _next() {
    setState(() {
      _index += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _widgets[_index](_prev, _next, widget.goHome, _restart);
  }
}
