import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NextPreviousButtons extends StatelessWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;
  final int maxPageValue;
  final bool isNextButtonEnabled;
  final bool Function()? onNext;
  const NextPreviousButtons(
      {super.key,
      required this.pageController,
      required this.currentPage,
      required this.maxPageValue,
      required this.isNextButtonEnabled,
      this.onNext});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentPage,
        builder: (context, page, child) => Padding(
            padding: EdgeInsets.only(
                top: getViewPortHeight(context) * 0.04,
                bottom: getViewPortHeight(context) * 0.02,
                left: getViewPortWidth(context) * 0.04,
                right: getViewPortWidth(context) * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: page == 1
                      ? null
                      : () {
                          int pageValue = page - 1;
                          currentPage.value = pageValue;
                          pageController.animateToPage(pageValue,
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeIn);
                        },
                  style: ButtonStyle(
                      splashFactory: InkSparkle.splashFactory,
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      fixedSize: WidgetStatePropertyAll(Size(
                          getViewPortWidth(context) * 0.4,
                          getViewPortHeight(context) * 0.05))),
                  child: Text(
                    AppLocalizations.of(context).nextPreviousButtonsPrevious,
                  ),
                ),
                ElevatedButton(
                  onPressed: page == maxPageValue || !isNextButtonEnabled
                      ? null
                      : () {
                          var next = onNext;
                          bool shouldNext = true;
                          if (next != null) {
                            shouldNext = next();
                          }
                          if (shouldNext) {
                            int pageValue = page + 1;
                            currentPage.value = pageValue;
                            pageController.animateToPage(pageValue,
                                duration: const Duration(milliseconds: 150),
                                curve: Curves.easeIn);
                          }
                        },
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      fixedSize: WidgetStatePropertyAll(Size(
                          getViewPortWidth(context) * 0.4,
                          getViewPortHeight(context) * 0.05))),
                  child: Text(
                    AppLocalizations.of(context).nextPreviousButtonsNext,
                  ),
                ),
              ],
            )));
  }
}
