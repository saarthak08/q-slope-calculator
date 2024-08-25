import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class CustomProgressIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  const CustomProgressIndicator({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    final vpH = getViewPortHeight(context);
    return SizedBox(
        height: size ?? vpH * 0.025,
        width: size ?? vpH * 0.025,
        child: Platform.isIOS
            ? CupertinoActivityIndicator(color: color)
            : CircularProgressIndicator(
                strokeWidth: 1,
                color: color ?? primaryColor,
              ));
  }
}
