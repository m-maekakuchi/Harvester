import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShapeBorder shapeBorder;

  // 角丸の長方形
  ShimmerWidget.roundedRectangular({
    super.key,
    required this.width,
    required this.height,
    required this.borderRadius
  }) : shapeBorder = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(borderRadius)
  );

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: ShapeDecoration(
          color: Colors.grey,
          shape: shapeBorder
        ),
      )
    );
  }
}
