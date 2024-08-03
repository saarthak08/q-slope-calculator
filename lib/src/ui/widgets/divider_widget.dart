import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';

class DividerWidget extends StatelessWidget {
  final Color? color;
  const DividerWidget({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final width = getDeviceWidth(context);
    return Container(
      alignment: Alignment.bottomCenter,
      height: 0.5,
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade400,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      width: width,
    );
  }
}
