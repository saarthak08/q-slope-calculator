import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/save_file.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:q_slope_calculator/src/ui/screens/q_slope_stability_chart_screen/components/q_slope_stability_information_widget.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';

class QSlopeStabilityChartScreen extends StatelessWidget {
  static const route = "/qslope-stability-chart";
  final QSlopeStabilityChartScreenArguments qSlopeStabilityChartScreenArguments;
  QSlopeStabilityChartScreen({
    super.key,
    required this.qSlopeStabilityChartScreenArguments,
  });
  final GlobalKey<SfCartesianChartState> _cartesianChartKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final vpH = getViewPortHeight(context);
    final vpW = getViewPortWidth(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: primaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton(
            iconColor: primaryColor,
            itemBuilder:
                (buildContext) => [
                  PopupMenuItem(
                    onTap: () async {
                      final ui.Image? data = await _cartesianChartKey
                          .currentState!
                          .toImage(pixelRatio: 3.0);
                      final ByteData? bytes = await data!.toByteData(
                        format: ui.ImageByteFormat.png,
                      );
                      final Uint8List imageBytes = bytes!.buffer.asUint8List(
                        bytes.offsetInBytes,
                        bytes.lengthInBytes,
                      );
                      final fileName =
                          "q-slope-stability-chart_${DateTime.now().toIso8601String().replaceAll(":", "-")}.png";
                      try {
                        if (buildContext.mounted) {
                          await saveFile(
                            imageBytes.toList(),
                            fileName,
                            buildContext,
                          );
                          if (buildContext.mounted) {
                            toastification.show(
                              autoCloseDuration: const Duration(seconds: 2),
                              alignment: Alignment.bottomCenter,
                              type: ToastificationType.success,
                              title: Text(
                                AppLocalizations.of(
                                  buildContext,
                                ).exportSuccessful(fileName),
                              ),
                            );
                          }
                        }
                      } catch (err) {
                        if (buildContext.mounted) {
                          toastification.show(
                            autoCloseDuration: const Duration(seconds: 2),
                            alignment: Alignment.bottomCenter,
                            type: ToastificationType.error,
                            title: Text(
                              AppLocalizations.of(
                                buildContext,
                              ).chartExportFailed,
                            ),
                          );
                          rethrow;
                        }
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.drive_folder_upload, color: primaryColor),
                        SizedBox(width: getViewPortWidth(context) * 0.01),
                        Text(AppLocalizations.of(context).exportChart),
                      ],
                    ),
                  ),
                ],
          ),
        ],
        title: Text(
          AppLocalizations.of(context).qSlopeStabilityChart,
          style: TextStyle(fontSize: getTitleFontSize(context)),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(right: vpW * 0.05, left: vpW * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: vpH * 0.02),
              SizedBox(
                height: vpH * 0.7,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 1000),
                    child: SfCartesianChart(
                      backgroundColor: Colors.white,
                      key: _cartesianChartKey,
                      legend: Legend(
                        isVisible: true,
                        isResponsive: true,
                        toggleSeriesVisibility: false,
                        overflowMode: LegendItemOverflowMode.wrap,
                      ),
                      enableAxisAnimation: true,
                      annotations:
                          qSlopeStabilityChartScreenArguments.qSlopeValues
                              .mapIndexed(
                                (i, qSlopeValue) => CartesianChartAnnotation(
                                  widget: Tooltip(
                                    message:
                                        "${AppLocalizations.of(context).chartPointAnnotation}-${i + 1} (${qSlopeValue.toStringAsFixed(2)},${calculateSlopeAngle(qSlopeValue).toStringAsFixed(0)})",
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.indigo,
                                      size: 10,
                                    ),
                                  ),
                                  coordinateUnit: CoordinateUnit.point,
                                  x: qSlopeValue,
                                  y: calculateSlopeAngle(qSlopeValue),
                                ),
                              )
                              .toList() +
                          qSlopeStabilityChartScreenArguments.slopeAnglesByUser
                              .mapIndexed(
                                (
                                  i,
                                  slopeAngleByUser,
                                ) => CartesianChartAnnotation(
                                  widget:
                                      slopeAngleByUser != null
                                          ? Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Align(
                                                heightFactor: 2.25,
                                                widthFactor: 2.25,
                                                alignment: Alignment.topCenter,
                                                child: Text(
                                                  "${AppLocalizations.of(context).chartPointAnnotation}-${i + 1}",
                                                  style: TextStyle(
                                                    fontSize:
                                                        getCaptionFontSize(
                                                          context,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                              Tooltip(
                                                message:
                                                    "(${qSlopeStabilityChartScreenArguments.qSlopeValues[i].toStringAsFixed(2)},${slopeAngleByUser.toStringAsFixed(0)})",
                                                child: Icon(
                                                  Icons.pentagon,
                                                  color: Colors.black,
                                                  size: 10,
                                                ),
                                              ),
                                            ],
                                          )
                                          : Container(),
                                  coordinateUnit: CoordinateUnit.point,
                                  x:
                                      qSlopeStabilityChartScreenArguments
                                          .qSlopeValues[i],
                                  y: slopeAngleByUser ?? 0,
                                ),
                              )
                              .toList() +
                          ([
                            CartesianChartAnnotation(
                              widget: Text(
                                AppLocalizations.of(context).unstableSlopes,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getCaptionFontSize(context),
                                ),
                              ),
                              coordinateUnit: CoordinateUnit.point,
                              clip: ChartClipBehavior.clip,
                              x: 0.01,
                              y: 65,
                            ),
                            CartesianChartAnnotation(
                              widget: Text(
                                AppLocalizations.of(
                                  context,
                                ).slopeStabilityUncertainChartAreaLabel,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getCaptionFontSize(context),
                                ),
                              ),
                              clip: ChartClipBehavior.clip,
                              coordinateUnit: CoordinateUnit.point,
                              x:
                                  ResponsiveBreakpoints.of(context).isMobile
                                      ? 0.0028
                                      : 0.002,
                              y: 12,
                            ),
                            CartesianChartAnnotation(
                              widget: Text(
                                AppLocalizations.of(context).stableSlopes,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getCaptionFontSize(context),
                                ),
                              ),
                              clip: ChartClipBehavior.clip,
                              coordinateUnit: CoordinateUnit.point,
                              x: 2,
                              y: 25,
                            ),
                            CartesianChartAnnotation(
                              widget: Text(
                                ResponsiveBreakpoints.of(context).isMobile
                                    ? ""
                                    : AppLocalizations.of(
                                      context,
                                    ).slopeAngleQSlopeFormula,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: getCaptionFontSize(context),
                                ),
                              ),
                              clip: ChartClipBehavior.clip,
                              coordinateUnit: CoordinateUnit.point,
                              x: 3,
                              y: 48,
                            ),
                          ]),
                      series: [
                        LineSeries(
                          xValueMapper: (datum, int index) {
                            return null;
                          },
                          yValueMapper: (datum, int index) {
                            return null;
                          },
                          isVisibleInLegend: true,
                          legendIconType: LegendIconType.circle,
                          color: Colors.indigo,
                          name:
                              '(${AppLocalizations.of(context).qSlopeSymbol}, ${AppLocalizations.of(context).slopeAngleSymbol})',
                        ),
                        LineSeries(
                          xValueMapper: (datum, int index) {
                            return null;
                          },
                          yValueMapper: (datum, int index) {
                            return null;
                          },
                          isVisibleInLegend: true,
                          legendIconType: LegendIconType.pentagon,
                          color: Colors.black,
                          name:
                              '(${AppLocalizations.of(context).qSlopeSymbol}, ${AppLocalizations.of(context).slopeAngleProvidedByUserSymbol})',
                        ),
                        AreaSeries(
                          xValueMapper: (coordinate, _) => coordinate.x,
                          yValueMapper: (coordinate, _) => coordinate.y,
                          dataSource: uncertainSlopeStabilityCoordinates,
                          color: Colors.grey.withValues(alpha: 0.2),
                          legendItemText:
                              AppLocalizations.of(
                                context,
                              ).slopeStabilityUncertain,
                          isVisibleInLegend: true,
                        ),
                        AreaSeries(
                          xValueMapper: (coordinate, _) => coordinate.x,
                          yValueMapper: (coordinate, _) => coordinate.y,
                          dataSource: unstableSlopeAreaCoordinates,
                          color: Colors.red.withValues(alpha: 0.42),
                          legendItemText:
                              AppLocalizations.of(context).unstableSlopes,
                          isVisibleInLegend: true,
                        ),
                        AreaSeries(
                          xValueMapper: (coordinate, _) => coordinate.x,
                          yValueMapper: (coordinate, _) => coordinate.y,
                          dataSource: stableSlopeAreaCoordinates,
                          color: Colors.green.withValues(alpha: 0.42),
                          legendItemText:
                              AppLocalizations.of(context).stableSlopes,
                          isVisibleInLegend: true,
                        ),
                        LineSeries(
                          enableTooltip: true,
                          dataSource: lineOfBestFitForStableSlopesCoordindates,
                          xValueMapper: (coordinate, _) => coordinate.x,
                          yValueMapper: (coordinate, _) => coordinate.y,
                          color: Colors.green,
                          legendItemText:
                              AppLocalizations.of(
                                context,
                              ).lineOfBestFitForStableSlopes,
                          isVisibleInLegend: true,
                        ),
                      ],
                      primaryXAxis: LogarithmicAxis(
                        maximum: 100,
                        minimum: 0.001,
                        logBase: 10,
                        title: AxisTitle(
                          text:
                              AppLocalizations.of(
                                context,
                              ).stabilityChartXAxisTitle,
                          textStyle: TextStyle(
                            fontSize: getBodyFontSize(context),
                          ),
                        ),
                      ),
                      primaryYAxis: NumericAxis(
                        maximum: 90,
                        minimum: 0,
                        title: AxisTitle(
                          text:
                              AppLocalizations.of(
                                context,
                              ).stabilityChartYAxisTitle,
                          textStyle: TextStyle(
                            fontSize: getBodyFontSize(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    qSlopeStabilityChartScreenArguments.qSlopeValues.length,
                itemBuilder: (context, index) {
                  return QSlopeStabilityInformationWidget(
                    qSlopeValue:
                        qSlopeStabilityChartScreenArguments.qSlopeValues[index],
                    slopeAngleByUser:
                        qSlopeStabilityChartScreenArguments
                            .slopeAnglesByUser[index],
                    isSinglePoint:
                        qSlopeStabilityChartScreenArguments
                            .qSlopeValues
                            .length <=
                        1,
                    index: index,
                  );
                },
              ),
              SizedBox(height: vpH * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class QSlopeStabilityChartScreenArguments {
  final List<double> qSlopeValues;
  final List<double?> slopeAnglesByUser;

  QSlopeStabilityChartScreenArguments({
    required this.qSlopeValues,
    required this.slopeAnglesByUser,
  });
}
