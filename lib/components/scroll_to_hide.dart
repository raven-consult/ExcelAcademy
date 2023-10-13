import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollToHideWidget extends StatefulWidget {
  final Widget child;
  final ScrollController controller;

  const ScrollToHideWidget({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidget();
}

class _ScrollToHideWidget extends State<ScrollToHideWidget> {
  bool _isVisible = true;

  void _listen() {
    var direction = widget.controller.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      _hide();
    } else if (direction == ScrollDirection.forward) {
      _show();
    }
  }

  void _show() {
    if (!_isVisible) {
      setState(() {
        _isVisible = true;
      });
    }
  }

  void _hide() {
    if (_isVisible) {
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listen);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: _isVisible ? 150 : 0,
      duration: const Duration(milliseconds: 300),
      child: Wrap(
        children: [
          widget.child,
        ],
      ),
    );
  }
}
