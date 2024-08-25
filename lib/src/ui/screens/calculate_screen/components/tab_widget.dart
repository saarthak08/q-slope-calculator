import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TabWidget extends StatelessWidget {
  final ValueNotifier<List<bool>> errorTabs;
  final String tabText;
  final int tabBarIndex;
  const TabWidget(
      {super.key,
      required this.errorTabs,
      required this.tabText,
      required this.tabBarIndex});

  @override
  Widget build(BuildContext context) {
    return Tab(
        child: SizedBox(
      width: ResponsiveBreakpoints.of(context).screenWidth < 700 ? 120 : 180,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                flex: 5,
                child: Text(
                  tabText,
                  maxLines: 2,
                )),
            ValueListenableBuilder<List<bool>>(
                valueListenable: errorTabs,
                builder: (context, value, child) => value[tabBarIndex]
                    ? Flexible(
                        child: Container(
                        margin: EdgeInsets.only(
                            left: getViewPortWidth(context) * 0.01),
                        height: getViewPortHeight(context) * 0.01,
                        width: getViewPortHeight(context) * 0.01,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: primaryColor,
                        ),
                      ))
                    : Container())
          ]),
    ));
  }
}
