import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:q_slope_calculator/src/constants/strings.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/save_file.dart';

class PdfReportUtils {
  /// Generates the complete PDF report document for a given QSlope record.
  static Future<pw.Document> generateReportDocument(QSlope qSlope) async {
    final pdf = pw.Document(
      title: 'Q-Slope Geotechnical Report - ${qSlope.locationId ?? qSlope.id}',
      author: 'Q-Slope Calculator',
    );

    final double qVal = qSlope.qSlope ?? calculateQSlope(qSlope);
    final double allowableBeta = calculateSlopeAngle(qVal);
    final double? actualAngle = qSlope.slopeAngleByUser;
    final double? margin = calculateSafetyMargin(qVal, actualAngle);
    final SlopeStabilityStatus status = getSlopeStabilityStatus(
      qVal,
      actualAngle,
    );
    final SlopeSupportRecommendation support = getSlopeSupportRecommendation(
      qVal,
      benchHeight: qSlope.benchHeight,
      actualSlopeAngle: actualAngle,
    );

    // Kinematic evaluation if angles present
    KinematicAnalysisResult? kinematics;
    if (qSlope.oFactor?.betaS != null &&
        qSlope.oFactor?.alphaS != null &&
        qSlope.oFactor?.betaJ != null &&
        qSlope.oFactor?.alphaJ != null) {
      kinematics = analyzeKinematics(
        slopeDip: qSlope.oFactor!.betaS!,
        slopeDipDirection: qSlope.oFactor!.alphaS!,
        joint1Dip: qSlope.oFactor!.betaJ!,
        joint1DipDirection: qSlope.oFactor!.alphaJ!,
        joint2Dip: qSlope.oFactor!.betaI,
        joint2DipDirection: qSlope.oFactor!.alphaI,
      );
    }

    // Load image paths if available
    final List<pw.MemoryImage> photoImages = [];
    final imagePaths = qSlope.imagePaths ?? qSlope.photoPaths;
    if (imagePaths != null && !kIsWeb) {
      for (final p in imagePaths) {
        try {
          final file = File(p);
          if (await file.exists()) {
            final bytes = await file.readAsBytes();
            photoImages.add(pw.MemoryImage(bytes));
          }
        } catch (e) {
          debugPrint('Error reading photo for PDF: $e');
        }
      }
    }

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final formattedDate = dateFormat.format(qSlope.createdAt ?? DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'GEOTECHNICAL INVESTIGATION REPORT',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey900,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Rock Slope Stability Assessment (Q-Slope Method)',
                      style: const pw.TextStyle(
                        fontSize: 11,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      'Based on Bar & Barton (2015, 2017)',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Date: $formattedDate',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.Text(
                      'ID: ${qSlope.id.substring(0, qSlope.id.length > 8 ? 8 : qSlope.id.length)}',
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Divider(thickness: 1.5, color: PdfColors.blueGrey800),
            pw.SizedBox(height: 12),

            // Site Identification & GPS Table
            pw.Container(
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(color: PdfColors.grey300),
              ),
              padding: const pw.EdgeInsets.all(10),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Location ID:', qSlope.locationId ?? 'N/A'),
                      pw.SizedBox(height: 4),
                      _buildInfoRow('Lithology:', qSlope.lithology ?? 'N/A'),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          _buildLocationPinIcon(),
                          pw.SizedBox(width: 4),
                          _buildInfoRow(
                            'Coordinates:',
                            qSlope.latitude != null && qSlope.longitude != null
                                ? '${qSlope.latitude!.toStringAsFixed(5)}°, ${qSlope.longitude!.toStringAsFixed(5)}°'
                                : 'Not recorded',
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 4),
                      _buildInfoRow(
                        'Elevation:',
                        qSlope.elevation != null
                            ? '${qSlope.elevation!.toStringAsFixed(1)} m'
                            : 'N/A',
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        'Bench Height (H):',
                        qSlope.benchHeight != null
                            ? '${qSlope.benchHeight!.toStringAsFixed(1)} m'
                            : '15.0 m (standard)',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Stability Verdict Banner with Vector Icon
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              decoration: pw.BoxDecoration(
                color: _getStatusBgPdfColor(status),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
                border: pw.Border.all(
                  color: _getStatusBorderPdfColor(status),
                  width: 1.5,
                ),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                    children: [
                      _buildStatusIcon(status),
                      pw.SizedBox(width: 10),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'STABILITY VERDICT: ${status.name.toUpperCase()}',
                            style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold,
                              color: _getStatusTextPdfColor(status),
                            ),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            margin != null
                                ? 'Safety Margin: ${margin >= 0 ? "+" : ""}${margin.toStringAsFixed(1)}°'
                                : 'Empirical Allowable Angle: ${allowableBeta.toStringAsFixed(1)}°',
                            style: pw.TextStyle(
                              fontSize: 11,
                              color: _getStatusTextPdfColor(status),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Row(
                    children: [
                      _buildMetricBox('Q-Slope', qVal.toStringAsFixed(4)),
                      pw.SizedBox(width: 8),
                      _buildMetricBox(
                        'Beta Allowable',
                        '${allowableBeta.toStringAsFixed(1)}°',
                      ),
                      pw.SizedBox(width: 8),
                      _buildMetricBox(
                        'Beta Actual',
                        actualAngle != null
                            ? '${actualAngle.toStringAsFixed(1)}°'
                            : 'N/A',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Rock Mass Parameters Breakdown
            pw.Row(
              children: [
                _buildTableIcon(),
                pw.SizedBox(width: 6),
                pw.Text(
                  '1. Rock Mass Parameter Classification',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey900,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _tableHeaderCell('Parameter'),
                    _tableHeaderCell('Symbol'),
                    _tableHeaderCell('Rated Value'),
                    _tableHeaderCell('Geotechnical Meaning / Empirical Basis'),
                  ],
                ),
                _tableDataRow(
                  'Rock Quality Designation',
                  'RQD',
                  '${qSlope.blockSize?.rqd?.toStringAsFixed(1) ?? "0"}%',
                  'Core recovery or Palmstrom volumetric joint count (Jv)',
                ),
                _tableDataRow(
                  'Joint Set Number',
                  'Jn',
                  qSlope.blockSize?.jointSetNumber?.toStringAsFixed(1) ?? '1.0',
                  'Foliation, joint sets, and random joint configuration',
                ),
                _tableDataRow(
                  'Discontinuity Roughness',
                  'Jr',
                  qSlope.jointCharacter?.jointRoughness?.join(', ') ?? '1.0',
                  'Small-scale waviness and smoothness of joint surface',
                ),
                _tableDataRow(
                  'Discontinuity Alteration',
                  'Ja',
                  qSlope.jointCharacter?.jointAlteration?.join(', ') ?? '1.0',
                  'Joint wall alteration, infilling mineralogy, and gouge',
                ),
                _tableDataRow(
                  'Orientation Factor',
                  'O-factor',
                  '${qSlope.oFactor?.oFactorForFirstJoint ?? 1.0} (${qSlope.oFactor?.oFactorTypeOfFailure?.name ?? "Planar"})',
                  'Kinematic alignment of joint vs slope face (Romana F1 x F2 x F3)',
                ),
                _tableDataRow(
                  'Environmental / Water Factor',
                  'Jwice',
                  qSlope
                          .externalFactors
                          ?.environmentalAndGeologicalConditionalNumber
                          ?.toStringAsFixed(2) ??
                      '1.0',
                  'Groundwater seepage, weathering, and ice-wedging exposure',
                ),
                _tableDataRow(
                  'Stress Reduction Factor',
                  'SRF',
                  qSlope.activeStress?.srf?.toStringAsFixed(1) ?? '1.0',
                  'Physical slope stress, blasting damage, and weakness zones',
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            // Empirical Support & Reinforcement Recommendations
            pw.Row(
              children: [
                _buildReinforcementIcon(),
                pw.SizedBox(width: 6),
                pw.Text(
                  '2. Empirical Slope Reinforcement Guide (Bar & Barton 2017)',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey900,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 6),
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    support.title,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey900,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    support.summary,
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.grey800,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Rock Bolting:',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              support.boltSpecification,
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                            if (support.recommendedBoltLengthMeters > 0)
                              pw.Text(
                                'Recommended Bolt Length L ~ ${support.recommendedBoltLengthMeters} m',
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.blue800,
                                ),
                              ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Shotcrete & Retention:',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              support.shotcreteSpecification,
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Drainage / Pore Pressure:',
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              support.drainageSpecification,
                              style: const pw.TextStyle(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Kinematic Assessment Section
            if (kinematics != null) ...[
              pw.Row(
                children: [
                  _buildCompassIcon(),
                  pw.SizedBox(width: 6),
                  pw.Text(
                    '3. Kinematic Failure Assessment',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey900,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(
                    pw.Radius.circular(4),
                  ),
                  color: PdfColors.grey50,
                ),
                padding: const pw.EdgeInsets.all(10),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        _buildKinematicChip(
                          'Planar Sliding',
                          kinematics.planarRisk,
                        ),
                        _buildKinematicChip(
                          'Wedge Sliding',
                          kinematics.wedgeRisk,
                        ),
                        _buildKinematicChip(
                          'Toppling Failure',
                          kinematics.topplingRisk,
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Mechanism: ${kinematics.primaryMechanismDescription}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Engineering Action: ${kinematics.engineeringRecommendation}',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),
            ],

            // Photo Gallery Section if images present
            if (photoImages.isNotEmpty) ...[
              pw.Row(
                children: [
                  _buildCameraIcon(),
                  pw.SizedBox(width: 6),
                  pw.Text(
                    '4. Field Outcrop & Discontinuity Images',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey900,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    photoImages.map((img) {
                      return pw.Container(
                        width: 150,
                        height: 110,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey400),
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(4),
                          ),
                        ),
                        child: pw.ClipRRect(
                          horizontalRadius: 4,
                          verticalRadius: 4,
                          child: pw.Image(img, fit: pw.BoxFit.cover),
                        ),
                      );
                    }).toList(),
              ),
              pw.SizedBox(height: 20),
            ],

            // Sign-off / Engineering Stamp block
            pw.Divider(color: PdfColors.grey300),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildStampPenIcon(),
                    pw.SizedBox(width: 6),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Prepared By: __________________________',
                          style: const pw.TextStyle(fontSize: 9),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Engineering Geologist / Geotechnical Eng.',
                          style: const pw.TextStyle(
                            fontSize: 8,
                            color: PdfColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Reviewed / Stamped: __________________________',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Principal Geotechnical Engineer (PE/CPEng)',
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf;
  }

  /// Exports the generated PDF report to disk using saveFile.
  static Future<String?> exportPdfReport(
    QSlope qSlope, {
    String? dialogTitle,
  }) async {
    final pdf = await generateReportDocument(qSlope);
    final bytes = await pdf.save();
    final fileName = generateExportFileName(
      '$pdfReportFilePrefix${qSlope.locationId ?? qSlope.id.substring(0, qSlope.id.length > 8 ? 8 : qSlope.id.length)}',
      pdfFileExtension,
    );
    final result = await saveFile(bytes.toList(), fileName, null, dialogTitle);
    if (result == null) return null;
    return fileName;
  }

  /// Directly invokes print preview or share modal.
  static Future<void> printOrSharePdf(QSlope qSlope) async {
    final pdf = await generateReportDocument(qSlope);
    final bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'q_slope_report_${qSlope.locationId ?? "calculation"}.pdf',
    );
  }

  // --- Vector Icon Drawing Functions for Crisp PDF Output ---

  static pw.Widget _buildStatusIcon(SlopeStabilityStatus status) {
    return pw.CustomPaint(
      size: const PdfPoint(20, 20),
      painter: (PdfGraphics canvas, PdfPoint size) {
        final double cx = size.x / 2;
        final double cy = size.y / 2;
        final double r = size.x / 2;

        switch (status) {
          case SlopeStabilityStatus.stable:
            // Green filled circle with checkmark
            canvas.setFillColor(PdfColors.green800);
            canvas.drawEllipse(cx, cy, r, r);
            canvas.fillPath();

            canvas.setColor(PdfColors.white);
            canvas.setLineWidth(1.8);
            canvas.moveTo(size.x * 0.28, size.y * 0.50);
            canvas.lineTo(size.x * 0.44, size.y * 0.32);
            canvas.lineTo(size.x * 0.74, size.y * 0.68);
            canvas.strokePath();
            break;

          case SlopeStabilityStatus.uncertain:
            // Amber triangle with exclamation mark
            canvas.setFillColor(PdfColors.amber800);
            canvas.moveTo(size.x * 0.5, size.y * 0.95);
            canvas.lineTo(size.x * 0.95, size.y * 0.1);
            canvas.lineTo(size.x * 0.05, size.y * 0.1);
            canvas.fillPath();

            canvas.setColor(PdfColors.white);
            canvas.setLineWidth(1.8);
            canvas.drawLine(
              size.x * 0.5,
              size.y * 0.70,
              size.x * 0.5,
              size.y * 0.40,
            );
            canvas.strokePath();

            canvas.setFillColor(PdfColors.white);
            canvas.drawEllipse(size.x * 0.5, size.y * 0.25, 1.2, 1.2);
            canvas.fillPath();
            break;

          case SlopeStabilityStatus.unstable:
            // Red circle with white cross
            canvas.setFillColor(PdfColors.red800);
            canvas.drawEllipse(cx, cy, r, r);
            canvas.fillPath();

            canvas.setColor(PdfColors.white);
            canvas.setLineWidth(1.8);
            canvas.drawLine(
              size.x * 0.30,
              size.y * 0.30,
              size.x * 0.70,
              size.y * 0.70,
            );
            canvas.drawLine(
              size.x * 0.30,
              size.y * 0.70,
              size.x * 0.70,
              size.y * 0.30,
            );
            canvas.strokePath();
            break;

          case SlopeStabilityStatus.unknown:
            canvas.setFillColor(PdfColors.grey600);
            canvas.drawEllipse(cx, cy, r, r);
            canvas.fillPath();
            break;
        }
      },
    );
  }

  static pw.Widget _buildLocationPinIcon() {
    return pw.CustomPaint(
      size: const PdfPoint(12, 12),
      painter: (PdfGraphics canvas, PdfPoint size) {
        canvas.setFillColor(PdfColors.blueGrey800);
        canvas.drawEllipse(
          size.x * 0.5,
          size.y * 0.65,
          size.x * 0.32,
          size.y * 0.32,
        );
        canvas.fillPath();
        canvas.moveTo(size.x * 0.22, size.y * 0.60);
        canvas.lineTo(size.x * 0.5, size.y * 0.05);
        canvas.lineTo(size.x * 0.78, size.y * 0.60);
        canvas.fillPath();
        canvas.setFillColor(PdfColors.white);
        canvas.drawEllipse(
          size.x * 0.5,
          size.y * 0.65,
          size.x * 0.12,
          size.y * 0.12,
        );
        canvas.fillPath();
      },
    );
  }

  static pw.Widget _buildTableIcon() {
    return pw.CustomPaint(
      size: const PdfPoint(12, 12),
      painter: (PdfGraphics canvas, PdfPoint size) {
        canvas.setColor(PdfColors.blueGrey800);
        canvas.setLineWidth(0.8);
        canvas.drawRect(
          size.x * 0.05,
          size.y * 0.05,
          size.x * 0.9,
          size.y * 0.9,
        );
        canvas.strokePath();
        canvas.drawLine(
          size.x * 0.05,
          size.y * 0.55,
          size.x * 0.95,
          size.y * 0.55,
        );
        canvas.drawLine(
          size.x * 0.5,
          size.y * 0.05,
          size.x * 0.5,
          size.y * 0.95,
        );
        canvas.strokePath();
      },
    );
  }

  static pw.Widget _buildReinforcementIcon() {
    return pw.CustomPaint(
      size: const PdfPoint(12, 12),
      painter: (PdfGraphics canvas, PdfPoint size) {
        canvas.setColor(PdfColors.blue800);
        canvas.setLineWidth(1.8);
        canvas.drawLine(
          size.x * 0.15,
          size.y * 0.15,
          size.x * 0.85,
          size.y * 0.85,
        );
        canvas.strokePath();
        canvas.setFillColor(PdfColors.blueGrey700);
        canvas.drawRect(
          size.x * 0.05,
          size.y * 0.05,
          size.x * 0.35,
          size.y * 0.15,
        );
        canvas.fillPath();
      },
    );
  }

  static pw.Widget _buildCompassIcon() {
    return pw.CustomPaint(
      size: const PdfPoint(12, 12),
      painter: (PdfGraphics canvas, PdfPoint size) {
        canvas.setColor(PdfColors.blueGrey700);
        canvas.setLineWidth(0.9);
        canvas.drawEllipse(
          size.x * 0.5,
          size.y * 0.5,
          size.x * 0.45,
          size.y * 0.45,
        );
        canvas.strokePath();
        canvas.setFillColor(PdfColors.red700);
        canvas.moveTo(size.x * 0.5, size.y * 0.9);
        canvas.lineTo(size.x * 0.38, size.y * 0.5);
        canvas.lineTo(size.x * 0.62, size.y * 0.5);
        canvas.fillPath();
        canvas.setFillColor(PdfColors.blueGrey400);
        canvas.moveTo(size.x * 0.5, size.y * 0.1);
        canvas.lineTo(size.x * 0.38, size.y * 0.5);
        canvas.lineTo(size.x * 0.62, size.y * 0.5);
        canvas.fillPath();
      },
    );
  }

  static pw.Widget _buildCameraIcon() {
    return pw.CustomPaint(
      size: const PdfPoint(12, 12),
      painter: (PdfGraphics canvas, PdfPoint size) {
        canvas.setFillColor(PdfColors.blueGrey700);
        canvas.drawRect(
          size.x * 0.05,
          size.y * 0.1,
          size.x * 0.9,
          size.y * 0.65,
        );
        canvas.fillPath();
        canvas.drawRect(
          size.x * 0.35,
          size.y * 0.75,
          size.x * 0.3,
          size.y * 0.18,
        );
        canvas.fillPath();
        canvas.setFillColor(PdfColors.white);
        canvas.drawEllipse(
          size.x * 0.5,
          size.y * 0.42,
          size.x * 0.22,
          size.y * 0.22,
        );
        canvas.fillPath();
      },
    );
  }

  static pw.Widget _buildStampPenIcon() {
    return pw.CustomPaint(
      size: const PdfPoint(12, 12),
      painter: (PdfGraphics canvas, PdfPoint size) {
        canvas.setColor(PdfColors.blueGrey700);
        canvas.setLineWidth(1.2);
        canvas.drawLine(
          size.x * 0.15,
          size.y * 0.85,
          size.x * 0.75,
          size.y * 0.25,
        );
        canvas.strokePath();
        canvas.setFillColor(PdfColors.blueGrey800);
        canvas.moveTo(size.x * 0.1, size.y * 0.9);
        canvas.lineTo(size.x * 0.25, size.y * 0.85);
        canvas.lineTo(size.x * 0.15, size.y * 0.75);
        canvas.fillPath();
      },
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(width: 4),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.black),
        ),
      ],
    );
  }

  static pw.Widget _buildMetricBox(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _tableHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.TableRow _tableDataRow(
    String param,
    String symbol,
    String val,
    String notes,
  ) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(param, style: const pw.TextStyle(fontSize: 8)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(
            symbol,
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(val, style: const pw.TextStyle(fontSize: 8)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: pw.Text(
            notes,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildKinematicChip(String mode, KinematicRiskLevel risk) {
    PdfColor color;
    switch (risk) {
      case KinematicRiskLevel.critical:
        color = PdfColors.red800;
        break;
      case KinematicRiskLevel.moderate:
        color = PdfColors.amber800;
        break;
      case KinematicRiskLevel.low:
        color = PdfColors.blueGrey600;
        break;
      case KinematicRiskLevel.none:
        color = PdfColors.green800;
        break;
    }
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text('$mode: ', style: const pw.TextStyle(fontSize: 9)),
        pw.Text(
          risk.name.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  static PdfColor _getStatusBgPdfColor(SlopeStabilityStatus status) {
    switch (status) {
      case SlopeStabilityStatus.stable:
        return const PdfColor(0.90, 0.96, 0.90);
      case SlopeStabilityStatus.uncertain:
        return const PdfColor(1.0, 0.98, 0.88);
      case SlopeStabilityStatus.unstable:
        return const PdfColor(1.0, 0.90, 0.90);
      case SlopeStabilityStatus.unknown:
        return PdfColors.grey100;
    }
  }

  static PdfColor _getStatusBorderPdfColor(SlopeStabilityStatus status) {
    switch (status) {
      case SlopeStabilityStatus.stable:
        return PdfColors.green700;
      case SlopeStabilityStatus.uncertain:
        return PdfColors.amber700;
      case SlopeStabilityStatus.unstable:
        return PdfColors.red700;
      case SlopeStabilityStatus.unknown:
        return PdfColors.grey400;
    }
  }

  static PdfColor _getStatusTextPdfColor(SlopeStabilityStatus status) {
    switch (status) {
      case SlopeStabilityStatus.stable:
        return PdfColors.green900;
      case SlopeStabilityStatus.uncertain:
        return PdfColors.orange900;
      case SlopeStabilityStatus.unstable:
        return PdfColors.red900;
      case SlopeStabilityStatus.unknown:
        return PdfColors.grey800;
    }
  }
}

// Backward compatibility alias
typedef PdfReportService = PdfReportUtils;
