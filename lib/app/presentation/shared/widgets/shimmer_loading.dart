import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final Widget widget;
  final bool isLoading;

  const ShimmerLoading({
    Key? key,
    required this.width,
    required this.height,
    required this.widget,
    this.isLoading = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: CupertinoColors.systemGrey5,
      highlightColor: CupertinoColors.systemGrey3,
      enabled: isLoading,
      child: SizedBox(
        width: width,
        height: height,
        child: widget,
      ),
    );
  }
} 