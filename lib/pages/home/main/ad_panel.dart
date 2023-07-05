import 'package:flutter/material.dart';

class AdPanel extends StatelessWidget {
  const AdPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[100],
      child: const FlutterLogo(
        size: 200,
        style: FlutterLogoStyle.horizontal,
      ),
    );
  }
}
