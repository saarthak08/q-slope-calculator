import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';

class IllustrationWidget extends StatelessWidget {
  final String assetPath;
  final String text;
  final double? height;
  final double? width;
  final Future<void> Function()? onRefresh;

  const IllustrationWidget(
      {super.key,
      required this.assetPath,
      required this.text,
      required this.onRefresh,
      this.width,
      this.height});

  @override
  Widget build(BuildContext context) {
    double vpH = getViewPortHeight(context);
    double vpW = getViewPortWidth(context);
    return SizedBox(
        height: (height ?? vpH) * 0.7,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 3,
                child: SizedBox(
                  height: (height ?? vpH) * 0.2,
                  width: (width ?? vpW) * 0.7,
                  child: SvgPicture.asset(assetPath),
                )),
            Flexible(
                child: SizedBox(
              height: (height ?? vpH) * 0.03,
            )),
            Flexible(
                child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: (width ?? vpW) * 0.1),
                    alignment: Alignment.center,
                    child: Text(
                      text,
                      style:
                          TextStyle(fontSize: (getSubTitleFontSize(context))),
                      textAlign: TextAlign.center,
                    ))),
            Flexible(
                child: SizedBox(
              height: (height ?? vpH) * 0.05,
            )),
            Flexible(
                child: onRefresh != null
                    ? TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.pressed)) {
                              return primaryColor.withOpacity(0.3);
                            }
                            return Colors.transparent;
                          }),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                              side: BorderSide(
                                  color: primaryColor,
                                  style: BorderStyle.solid))),
                          elevation: WidgetStateProperty.all(0),
                          fixedSize: WidgetStateProperty.all<Size>(
                              Size((width ?? vpW) * 0.1, (width ?? vpW) * 0.1)),
                        ),
                        onPressed: () async {
                          await onRefresh!();
                        },
                        child: const Icon(
                          Icons.refresh,
                        ))
                    : Container())
          ],
        )));
  }
}
