import 'package:flutter/material.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OFactorJointsOfFailureWidget extends StatelessWidget {
  final OFactorTypeOfFailure? oFactorTypeOfFailure;
  final ValueNotifier<QSlope> qSlope;
  final int? joint1Index;
  final int? joint2Index;
  final ValueNotifier<int?> joint1IndexValueNotifier;
  final ValueNotifier<int?> joint2IndexValueNotifier;
  final void Function() setQSlope;

  const OFactorJointsOfFailureWidget(
      {super.key,
      this.oFactorTypeOfFailure,
      required this.qSlope,
      this.joint1Index,
      this.joint2Index,
      required this.joint1IndexValueNotifier,
      required this.joint2IndexValueNotifier,
      required this.setQSlope});

  @override
  Widget build(BuildContext context) {
    return oFactorTypeOfFailure != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                SizedBox(
                  height: getViewPortHeight(context) * 0.03,
                ),
                Text(
                  AppLocalizations.of(context).selectJointsHavingFailure,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: getSubTitleFontSize(context)),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: getViewPortHeight(context) * 0.01,
                      ),
                      Flexible(
                          child: Container(
                              margin: const EdgeInsets.only(right: 30),
                              width: 100,
                              child: DropdownButton<int>(
                                  isExpanded: true,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  value: joint1Index,
                                  items: (List.generate(
                                          qSlope.value.blockSize
                                                  ?.numberOfJoints ??
                                              1,
                                          (index) => DropdownMenuItem(
                                              value: index,
                                              child: Text(
                                                  "${AppLocalizations.of(context).jointSymbol}${index + 1}")))
                                      .where(
                                          (value) => value.value != joint2Index)
                                      .toList()),
                                  onChanged: (value) {
                                    joint1IndexValueNotifier.value = value;
                                    setQSlope();
                                  }))),
                      oFactorTypeOfFailure == OFactorTypeOfFailure.wedge
                          ? Flexible(
                              child: SizedBox(
                                  width: 100,
                                  child: DropdownButton<int>(
                                      isExpanded: true,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      value: joint2Index,
                                      items: (List.generate(
                                              qSlope.value.blockSize
                                                      ?.numberOfJoints ??
                                                  1,
                                              (index) => DropdownMenuItem(
                                                  value: index,
                                                  child: Text(
                                                      "${AppLocalizations.of(context).jointSymbol}${(index + 1)}")))
                                          .where((value) =>
                                              value.value != joint1Index)
                                          .toList()),
                                      onChanged: (value) {
                                        joint2IndexValueNotifier.value = value;
                                        setQSlope();
                                      })))
                          : Container()
                    ])
              ])
        : Container();
  }
}
