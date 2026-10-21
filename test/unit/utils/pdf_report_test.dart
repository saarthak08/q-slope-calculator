import 'package:flutter_test/flutter_test.dart';
import 'package:q_slope_calculator/src/data/models/active_stress.dart';
import 'package:q_slope_calculator/src/data/models/block_size.dart';
import 'package:q_slope_calculator/src/data/models/external_factors.dart';
import 'package:q_slope_calculator/src/data/models/joint_character.dart';
import 'package:q_slope_calculator/src/data/models/o_factor.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/utils/pdf_report_utils.dart';

void main() {
  group('PdfReportUtils Geotechnical Report Generation Tests', () {
    test(
      'generateReportDocument produces valid PDF document without errors',
      () async {
        final qSlope = QSlope(
          id: 'pdf-test-1',
          locationId: 'Pit 4 Bench B',
          lithology: 'Sandstone',
          latitude: -31.9505,
          longitude: 115.8605,
          elevation: 250.0,
          benchHeight: 18.0,
          blockSize: BlockSize(
            rqd: 80.0,
            jointSetNumber: 4.0,
            numberOfJoints: 1,
          ),
          jointCharacter: JointCharacter(
            jointRoughness: [1.5],
            jointAlteration: [1.0],
          ),
          oFactor: OFactor(
            oFactorForFirstJoint: 0.95,
            alphaS: 120.0,
            betaS: 65.0,
            alphaJ: 115.0,
            betaJ: 45.0,
          ),
          externalFactors: ExternalFactors(
            environmentalAndGeologicalConditionalNumber: 0.7,
          ),
          activeStress: ActiveStress(srf: 2.0),
          qSlope: 0.4215,
          slopeAngleByUser: 60.0,
          createdAt: DateTime.now(),
        );

        final pdf = await PdfReportUtils.generateReportDocument(qSlope);
        expect(pdf, isNotNull);
        final bytes = await pdf.save();
        expect(bytes.isNotEmpty, isTrue);
        // PDF documents start with %PDF
        expect(bytes.sublist(0, 4), [0x25, 0x50, 0x44, 0x46]);
      },
    );
  });
}
