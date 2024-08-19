import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NextPreviousButtons extends StatelessWidget {
  final PageController pageController;
  final ValueNotifier<int> currentPage;
  final int maxPageValue;
  final bool isNextButtonEnabled;
  final bool Function()? onNext;
  final String? nextButtonText;

  const NextPreviousButtons(
      {super.key,
      required this.pageController,
      required this.currentPage,
      required this.maxPageValue,
      required this.isNextButtonEnabled,
      this.onNext,
      this.nextButtonText});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentPage,
        builder: (context, page, child) => Container(
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ]),
            padding: EdgeInsets.only(
                top: getViewPortHeight(context) * 0.01,
                bottom: getViewPortHeight(context) * 0.01,
                left: getViewPortWidth(context) * 0.08,
                right: getViewPortWidth(context) * 0.08),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                  onPressed: page == 0
                      ? null
                      : () {
                          int pageValue = page - 1;
                          currentPage.value = pageValue;
                          pageController.previousPage(
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn);
                        },
                  style: ButtonStyle(
                      splashFactory: InkSparkle.splashFactory,
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      fixedSize: WidgetStatePropertyAll(Size(
                          getViewPortWidth(context) * 0.35,
                          getViewPortHeight(context) * 0.05))),
                  child: Text(
                    AppLocalizations.of(context).nextPreviousButtonsPrevious,
                  ),
                ),
                ElevatedButton(
                  onPressed: !isNextButtonEnabled
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
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeIn);
                          }
                        },
                  style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                      fixedSize: WidgetStatePropertyAll(Size(
                          getViewPortWidth(context) * 0.35,
                          getViewPortHeight(context) * 0.05))),
                  child: Text(
                    nextButtonText ??
                        AppLocalizations.of(context).nextPreviousButtonsNext,
                  ),
                ),
              ],
            )));
  }
}
