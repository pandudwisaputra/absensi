import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmer({required double height, required double width}) {
  return Shimmer.fromColors(
    direction: ShimmerDirection.ltr,
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

Widget circleShimmer({required double height, required double width}) {
  return Shimmer.fromColors(
    direction: ShimmerDirection.ltr,
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    ),
  );
}
