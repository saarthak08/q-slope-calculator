// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Q-slope Calculator';

  @override
  String homeScreenAppBarSubtitle(Object author) {
    return 'by $author';
  }

  @override
  String get homeScreenCalculateButtonText => 'Calculate';

  @override
  String get homeScreenNoPreviousCalculationsFound =>
      'No previous calculations found';

  @override
  String get blockSizePageAppBarTitle => 'Basic Info & Block Size';

  @override
  String get blockSizePageBasicInformationSubTitle => 'Basic Information';

  @override
  String get blockSizePageBlockSizeSubTitle => 'Block Size';

  @override
  String get joinCharacterPageAppBarTitle => 'Joint Character';

  @override
  String get oFactorPageAppBarTitle => 'O-Factor';

  @override
  String get externalFactorsPageAppBarTitle => 'External Factors';

  @override
  String get activeStressPageAppBarTitle => 'Active Stress & Q-slope';

  @override
  String get locationIdTextInputTitle => 'Location Id';

  @override
  String get locationIdTextInputRequired => 'Location Id is required';

  @override
  String get lithologyTextInputTitle => 'Lithology';

  @override
  String get lithologyTextInputRequired => 'Lithology is required';

  @override
  String get sumOfCorePiecesTextInputTitle => 'Sum of Core Pieces (cm)';

  @override
  String get sumOfCorePiecesTextInputRequired =>
      'Sum of Core Pieces is required';

  @override
  String get sumOfCorePiecesTextInputHint =>
      'Only those core pieces should be taken into account that are greater than 10cm';

  @override
  String get totalDrillRunTextInputTitle => 'Total Drill Run (cm)';

  @override
  String get totalDrillRunTextInputRequired => 'Total Drill Run is required';

  @override
  String get totalDrillRunTextNotZero => 'Total Drill Run cannot be zero';

  @override
  String get numberOfJointsTextInputTitle => 'Number of Joints';

  @override
  String get jointSetNumber => 'Joint Set Number (Jn)';

  @override
  String get jointSetNumberSymbol => 'Jn';

  @override
  String get numberOfJointsTextInputRequired => 'Number of Joints is required';

  @override
  String get numberOfRandomSetsTextInputTitle => 'Number of Random Sets (Nr)';

  @override
  String get numberOfRandomSetsTextInputRequired =>
      'Number of Random Sets is required';

  @override
  String get areaTextInputTitle => 'Area (A) in sq. meters';

  @override
  String get areaTextInputRequired => 'Area is required';

  @override
  String get jointSpacingInMeters => 'Joint Spacing (S) in meters';

  @override
  String get jointSymbol => 'J';

  @override
  String get jointSpacingSymbol => 'S';

  @override
  String get jointVolume => 'Joint Volume (Jv)';

  @override
  String get numberOfRandomSetsSymbol => 'Nr';

  @override
  String get areaSymbol => 'A';

  @override
  String get rockQualityDesignationSymbol => 'RQD';

  @override
  String get jointVolumeSymbol => 'Jv';

  @override
  String get rockQualityDesignationCalculation =>
      'Rock Quality Designation Calculation (RQD):';

  @override
  String get byUsingJointVolumeMethod => 'By using Joint Volume Method';

  @override
  String get byUsingDirectMethod => 'By using Direct Method';

  @override
  String get rockQualityDesignation => 'Rock Quality Designation (RQD)';

  @override
  String get totalDrillRun => 'Total Drill Run';

  @override
  String get sumOfCorePieces => 'Sum of Core Pieces';

  @override
  String get numberOfJointsNotMoreThanHundred =>
      'Number of Joints cannot be more than 100';

  @override
  String get areaCannotBeZero => 'Area should be more than zero';

  @override
  String get nextPreviousButtonsNext => 'Next';

  @override
  String get nextPreviousButtonsPrevious => 'Previous';

  @override
  String get jointRoughnessInputTitle =>
      'Enter joint roughness value for all the joints: (0.5 - 4)';

  @override
  String get jointAlterationInputTitle =>
      'Enter joint alteration value for all the joints: (0.75 - 20)';

  @override
  String get jointRoughnessByValue => 'By value';

  @override
  String get jointRoughnessByPalmstrom => 'By Palmstrom method';

  @override
  String get jointRoughness => 'Joint Roughness (Jr)';

  @override
  String get jointRoughnessWithLimits => 'Joint Roughness (Jr) (0.5 - 4)';

  @override
  String get jointRoughnessSymbol => 'Jr';

  @override
  String get selectJointsHavingFailure =>
      'Please select the joints having failure';

  @override
  String get jointAlteration => 'Joint Alteration (Ja)';

  @override
  String get jointAlterationSymbol => 'Ja';

  @override
  String get jointWavyness => 'Joint Wavyness (Jw)';

  @override
  String get jointSmoothness => 'Joint Smoothness (Js)';

  @override
  String get jointWavynessSymbol => 'Jw';

  @override
  String get jointSmoothnessSymbol => 'Js';

  @override
  String get accordingToBarAndBarton => 'According to Bar & Barton (2017)';

  @override
  String get jointRoughnessRequired => 'Joint Roughness is required';

  @override
  String get jointRoughnessConstraintsValidation =>
      'Joint Roughness should be a value between 0.5 and 4';

  @override
  String get jointAlterationRequired => 'Joint Alteration is required';

  @override
  String get jointAlterationConstraintsValidation =>
      'Joint Alteration should be a value between 0.75 and 20';

  @override
  String get jointRoughnessTable => 'Joint Roughness Table';

  @override
  String get jointAlterationTable => 'Joint Alteration Table';

  @override
  String get oFactor => 'O-Factor';

  @override
  String get oFactorConstraints => '(0.25 - 2)';

  @override
  String get oFactorCalculation => 'O-Factor Calculation';

  @override
  String get enterOFactorsForTheJointsHavingFailures =>
      'Enter O-Factor value for the joints having failures';

  @override
  String get oFactorValueFor => 'O-Factor Value for';

  @override
  String get oFactorValue => 'O-Factor Value';

  @override
  String get oFactorValueInputConstraints =>
      'O-Factor value should be between 0.25 and 2';

  @override
  String get oFactorByValue => 'By value';

  @override
  String get calculateRomanaAdjustmentFactor =>
      'Calculate Romana\'s Adjustment Factor';

  @override
  String get romanaAdjustmentFactorByValue => 'By value';

  @override
  String get romanaAdjustmentFactorByF1F2F3 => 'By F1, F2, F3';

  @override
  String get oFactorByRomanaAdjustmentFactor =>
      'By using Romana\'s Adjustment Factors';

  @override
  String get discontinuityDipDirection => 'Discontinuity Dip Direction';

  @override
  String get trendOfTheIntersectionLineInCaseOfTheWedge =>
      'Trend of the Intersection Line in case of the Wedge';

  @override
  String get slopeDipDirection => 'Slope Dip Direction';

  @override
  String get dipOfTheDiscontinuity => 'Dip of the Discontinuity';

  @override
  String get plungeOfTheIntersectionLine => 'Plunge of the Intersection Line';

  @override
  String get dipOfTheSlope => 'Dip of the Slope';

  @override
  String get typeOfFailure => 'Type of Failure';

  @override
  String get romanaAdjustmentFactorSymbol => 'F';

  @override
  String get alphaISymbol => 'αi';

  @override
  String get alphaJSymbol => 'αj';

  @override
  String get alphaSSymbol => 'αs';

  @override
  String get betaISymbol => 'βi';

  @override
  String get betaJSymbol => 'βj';

  @override
  String get betaSSymbol => 'βs';

  @override
  String get isRequired => 'is required';

  @override
  String get planarFailure => 'Planar Failure';

  @override
  String get wedgeFailure => 'Wedge Failure';

  @override
  String get ratingForF1 => 'Rating for F1';

  @override
  String get ratingForF2 => 'Rating for F2';

  @override
  String get ratingForF3 => 'Rating for F3';

  @override
  String get formulaForRatingForF1 =>
      '16/25 - (3/500 * atan(1/10 * (|F1| - 17)))';

  @override
  String get formulaForRatingForF2 =>
      '9/16 + (1/195 * atan((17/100 * F2) - 5))';

  @override
  String get formulaForRatingForF3ForTopplingFailure =>
      '-13 - (1/7 * atan(F3 - 120))';

  @override
  String get formulaForRatingForF3ForNonTopplingFailure =>
      '-30 + (1/3 * atan(F3))';

  @override
  String get atan => 'atan';

  @override
  String get toppling => 'Toppling';

  @override
  String get valueOfF2 => 'Value of F2';

  @override
  String get jWiceCalculationBy => 'Jwice Calculation By';

  @override
  String get jWiceCalculationByValue => 'By value';

  @override
  String get jWiceCalculcationByExternalFactors => 'By External Factors';

  @override
  String get enviornmentalAndGeologicalConditionalNumber =>
      'Environmental and Geological Conditional Number (Jwice) (0.05 - 1)';

  @override
  String get enviornmentalAndGeologicalConditionalNumberSymbol => 'Jwice';

  @override
  String get jWiceInputConstraints =>
      'Jwice value should be between 0.05 and 1';

  @override
  String get externalFactorStructure => 'Structure';

  @override
  String get structureStable => 'Stable';

  @override
  String get structureUnstable => 'Unstable';

  @override
  String get strengthOfRock => 'Strength of Rock';

  @override
  String get strengthOfRockCompetent => 'Competent';

  @override
  String get strengthOfRockCompetentNote =>
      'Note: Rocks having UCS more than 50 MPa are considered as competent';

  @override
  String get strengthOfRockInCompetent => 'Incompetent';

  @override
  String get environmentalConditions => 'Environmental Conditions';

  @override
  String get desertEnvironment => 'Desert Environment';

  @override
  String get wetEnvironment => 'Wet Environment';

  @override
  String get tropicalStorms => 'Tropical Storms';

  @override
  String get iceWedging => 'Ice Wedging';

  @override
  String get stressReductionFactor => 'Stress Reduction Factor (SRF)';

  @override
  String get stressReductionFactorSymbol => 'SRF';

  @override
  String get srfA => 'SRFa';

  @override
  String get srfB => 'SRFb';

  @override
  String get srfC => 'SRFc';

  @override
  String get srfAInputTitle => 'SRFa (0 - 20)';

  @override
  String get srfBInputTitle => 'SRFb (1 - 200)';

  @override
  String get srfCInputTitle => 'SRFc (1 - 24)';

  @override
  String get maxOf => 'Maximum of';

  @override
  String get qSlopeSymbol => 'Q-slope';

  @override
  String get qSlopeCalculation => 'Q-slope Calculation';

  @override
  String get srfAInputConstraints => 'SRFa value should be between 0 and 20';

  @override
  String get srfBInputConstraints => 'SRFb value should be between 1 and 200';

  @override
  String get srfCInputConstraints => 'SRFc value should be between 1 and 24';

  @override
  String get activeStress => 'Active Stress';

  @override
  String get errorInSavingCalculation => 'Error in saving calculation';

  @override
  String get errorInDeletingCalculation => 'Error in deleting calculation';

  @override
  String get saveCalculationSuccessful => 'Calculation saved';

  @override
  String get deleteCalculationSuccessful => 'Calculation deleted';

  @override
  String get listLocationId => 'Location Id';

  @override
  String get listLithology => 'Lithology';

  @override
  String get createdAt => 'Created At';

  @override
  String get proudlyBuiltInIndia => 'Proudly built in India';

  @override
  String get aboutQSlope => 'About Q-slope';

  @override
  String get references => 'References';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get version => 'Version';

  @override
  String get aboutQSlopeInfo =>
      'Q-slope is an empirical rock slope engineering method for assessing the stability of excavated rock slopes in the field. Intended for use in reinforcement-free road or railway cuttings or in opencast mines, Q-slope allows geotechnical engineers to make potential adjustments to slope angles as rock mass conditions become apparent during construction.';

  @override
  String get save => 'Save';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get completeDialogTitle => 'Caution!';

  @override
  String get pleaseCompleteBlockSizeSection =>
      'Please complete the Basic Info and Block Size section before proceeding to this step.';

  @override
  String get exportFileTitle => 'Export Excel File';

  @override
  String get exportFileContent =>
      'Do you want to export calculations as an excel file?';

  @override
  String exportSuccessful(Object fileName) {
    return 'File exported successfully as $fileName';
  }

  @override
  String get exportFailed => 'File export failed';

  @override
  String get export => 'Export';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect All';

  @override
  String get delete => 'Delete';

  @override
  String get deleteCalculationsModalTitle => 'Delete Calculations';

  @override
  String get deleteCalculationsModalContent =>
      'Are you sure want to delete the selected calculations?';

  @override
  String get errorInLoadingQSlopeList =>
      'Error in loading Q-slope list. Please try removing app data or re-installing the app';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get selectDirectoryToSaveFile =>
      'Please select a directory to save the file';

  @override
  String get qSlopeStabilityChart => 'Q-slope Stability Chart';

  @override
  String get stabilityChart => 'Stability Chart';

  @override
  String get unstableSlopes => 'Unstable Slopes';

  @override
  String get slopeStabilityUncertain => 'Slope Stability Uncertain';

  @override
  String get stableSlopes => 'Stable Slopes';

  @override
  String get stabilityChartYAxisTitle => 'Slope Angle, β (degrees)';

  @override
  String get stabilityChartXAxisTitle => 'Q-slope';

  @override
  String get lineOfBestFitForStableSlopes =>
      'Line of Best Fit for Stable Slopes';

  @override
  String get logbase10 => 'log base 10';

  @override
  String get slopeAngleQSlopeFormula =>
      'Slope Angle β (degrees) = 20 x log(Q-slope) + 65°';

  @override
  String get slopeAngleSymbol => 'β';

  @override
  String get slopeAngleProvidedByUserSymbol => 'α';

  @override
  String get chartPointAnnotation => 'L';

  @override
  String get degreesSymbol => '°';

  @override
  String get slopeStabilityUncertainChartAreaLabel =>
      'Slope\nStability\nUncertain';

  @override
  String get slopeAngleByUser => 'Slope Angle (α) in degrees';

  @override
  String get slopeAngleProvidedAsInput =>
      'Slope Angle Provided as Input (α) in degrees';

  @override
  String get point => 'Point';

  @override
  String get notProvided => 'Not Provided';

  @override
  String get exportChart => 'Export Chart';

  @override
  String chartExportSuccessful(Object fileName) {
    return 'Chart exported successfully as $fileName';
  }

  @override
  String get chartExportFailed => 'Chart export failed';
}
