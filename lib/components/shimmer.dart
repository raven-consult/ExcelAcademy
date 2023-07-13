import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  ShimmerWidget.rectangular({
    super.key,
    this.height = 50.0,
    this.width = double.infinity,
  }) : shapeBorder = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        );

  const ShimmerWidget.circular({
    super.key,
    this.width = 64.0,
    this.height = 64.0,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          shape: shapeBorder,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
