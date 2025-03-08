import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class QSlopeStabilityChartScreen extends StatelessWidget {
  static const route = "/qslope-stability-chart";
  final List<double> qSlopeValues;
  const QSlopeStabilityChartScreen({super.key, required this.qSlopeValues});

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
                  child: SfCartesianChart(
                    legend: Legend(
                      isVisible: true,
                      isResponsive: true,
                      overflowMode: LegendItemOverflowMode.wrap,
                    ),
                    enableAxisAnimation: true,
                    trackballBehavior: TrackballBehavior(
                      enable: true,
                      activationMode: ActivationMode.longPress,
                    ),
                    annotations:
                        qSlopeValues
                            .map(
                              (qSlopeValue) => CartesianChartAnnotation(
                                widget: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.gps_fixed_outlined,
                                      color: Colors.black,
                                      size: 10,
                                    ),
                                    Text(
                                      "(${qSlopeValue.toStringAsFixed(2)}, ${calculateSlopeAngle(qSlopeValue).toStringAsFixed(0)})",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                coordinateUnit: CoordinateUnit.point,
                                x: qSlopeValue,
                                y: calculateSlopeAngle(qSlopeValue),
                              ),
                            )
                            .toList(),
                    series: [
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
                        dataSource: lineOfBestFitForStableSlopesCoordindates,
                        xValueMapper: (coordinate, _) => coordinate.x,
                        yValueMapper: (coordinate, _) => coordinate.y,
                        color: Colors.green,
                        markerSettings: MarkerSettings(
                          isVisible: true,
                          width: 3,
                          height: 3,
                          borderWidth: 3,
                        ),
                        legendItemText:
                            AppLocalizations.of(
                              context,
                            ).lineOfBestFitForStableSlopes,
                        isVisibleInLegend: true,
                      ),
                    ],
                    primaryXAxis: LogarithmicAxis(
                      desiredIntervals: 200,
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
              qSlopeValues.length == 1
                  ? Container(
                    padding: EdgeInsets.only(
                      left: vpW * 0.05,
                      right: vpW * 0.03,
                      top: vpH * 0.02,
                    ),
                    child: Text(
                      "${AppLocalizations.of(context).qSlopeSymbol} = ${qSlopeValues[0].toStringAsFixed(4)}",
                      style: GoogleFonts.montserrat(
                        fontFeatures: [],
                        fontWeight: FontWeight.w600,
                        fontSize: getSubTitleFontSize(context),
                      ),
                    ),
                  )
                  : Container(),
              qSlopeValues.length == 1
                  ? Container(
                    padding: EdgeInsets.only(
                      left: vpW * 0.05,
                      right: vpW * 0.03,
                      top: vpH * 0.02,
                    ),
                    child: Text(
                      AppLocalizations.of(context).slopeAngleQSlopeFormula,
                      style: GoogleFonts.montserrat(
                        fontFeatures: [],
                        fontWeight: FontWeight.w600,
                        fontSize: getSubTitleFontSize(context),
                      ),
                    ),
                  )
                  : Container(),
              qSlopeValues.length == 1
                  ? Container(
                    padding: EdgeInsets.only(
                      left: vpW * 0.05,
                      right: vpW * 0.03,
                      top: vpH * 0.02,
                    ),
                    child: Text(
                      "${AppLocalizations.of(context).slopeAngleSymbol} = 20 x log(${qSlopeValues[0].toStringAsFixed(4)}) + 65${AppLocalizations.of(context).degreesSymbol}",
                      style: GoogleFonts.montserrat(
                        fontFeatures: [],
                        fontWeight: FontWeight.w600,
                        fontSize: getSubTitleFontSize(context),
                      ),
                    ),
                  )
                  : Container(),
              qSlopeValues.length == 1
                  ? Container(
                    padding: EdgeInsets.only(
                      left: vpW * 0.05,
                      right: vpW * 0.03,
                      top: vpH * 0.02,
                    ),
                    child: Text(
                      "${AppLocalizations.of(context).slopeAngleSymbol} = ${calculateSlopeAngle(qSlopeValues[0]).toStringAsFixed(0)}${AppLocalizations.of(context).degreesSymbol}",
                      style: GoogleFonts.montserrat(
                        fontFeatures: [],
                        fontWeight: FontWeight.w600,
                        fontSize: getSubTitleFontSize(context),
                      ),
                    ),
                  )
                  : Container(),
              SizedBox(height: vpH * 0.1),
            ],
          ),
        ),
      ),
    );
  }
}
