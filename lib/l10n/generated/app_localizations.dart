import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Q-slope Calculator'**
  String get appName;

  /// No description provided for @homeScreenAppBarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'by {author}'**
  String homeScreenAppBarSubtitle(Object author);

  /// No description provided for @homeScreenCalculateButtonText.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get homeScreenCalculateButtonText;

  /// No description provided for @homeScreenNoPreviousCalculationsFound.
  ///
  /// In en, this message translates to:
  /// **'No previous calculations found'**
  String get homeScreenNoPreviousCalculationsFound;

  /// No description provided for @blockSizePageAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Info & Block Size'**
  String get blockSizePageAppBarTitle;

  /// No description provided for @blockSizePageBasicInformationSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get blockSizePageBasicInformationSubTitle;

  /// No description provided for @blockSizePageBlockSizeSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Block Size'**
  String get blockSizePageBlockSizeSubTitle;

  /// No description provided for @joinCharacterPageAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Joint Character'**
  String get joinCharacterPageAppBarTitle;

  /// No description provided for @oFactorPageAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'O-Factor'**
  String get oFactorPageAppBarTitle;

  /// No description provided for @externalFactorsPageAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'External Factors'**
  String get externalFactorsPageAppBarTitle;

  /// No description provided for @activeStressPageAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Stress & Q-slope'**
  String get activeStressPageAppBarTitle;

  /// No description provided for @locationIdTextInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Id'**
  String get locationIdTextInputTitle;

  /// No description provided for @locationIdTextInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Id is required'**
  String get locationIdTextInputRequired;

  /// No description provided for @lithologyTextInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Lithology'**
  String get lithologyTextInputTitle;

  /// No description provided for @lithologyTextInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Lithology is required'**
  String get lithologyTextInputRequired;

  /// No description provided for @sumOfCorePiecesTextInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Sum of Core Pieces (cm)'**
  String get sumOfCorePiecesTextInputTitle;

  /// No description provided for @sumOfCorePiecesTextInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Sum of Core Pieces is required'**
  String get sumOfCorePiecesTextInputRequired;

  /// No description provided for @sumOfCorePiecesTextInputHint.
  ///
  /// In en, this message translates to:
  /// **'Only those core pieces should be taken into account that are greater than 10cm'**
  String get sumOfCorePiecesTextInputHint;

  /// No description provided for @totalDrillRunTextInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Drill Run (cm)'**
  String get totalDrillRunTextInputTitle;

  /// No description provided for @totalDrillRunTextInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Total Drill Run is required'**
  String get totalDrillRunTextInputRequired;

  /// No description provided for @totalDrillRunTextNotZero.
  ///
  /// In en, this message translates to:
  /// **'Total Drill Run cannot be zero'**
  String get totalDrillRunTextNotZero;

  /// No description provided for @numberOfJointsTextInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Number of Joints'**
  String get numberOfJointsTextInputTitle;

  /// No description provided for @jointSetNumber.
  ///
  /// In en, this message translates to:
  /// **'Joint Set Number (Jn)'**
  String get jointSetNumber;

  /// No description provided for @jointSetNumberSymbol.
  ///
  /// In en, this message translates to:
  /// **'Jn'**
  String get jointSetNumberSymbol;

  /// No description provided for @numberOfJointsTextInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Number of Joints is required'**
  String get numberOfJointsTextInputRequired;

  /// No description provided for @numberOfRandomSetsTextInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Number of Random Sets (Nr)'**
  String get numberOfRandomSetsTextInputTitle;

  /// No description provided for @numberOfRandomSetsTextInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Number of Random Sets is required'**
  String get numberOfRandomSetsTextInputRequired;

  /// No description provided for @areaTextInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Area (A) in sq. meters'**
  String get areaTextInputTitle;

  /// No description provided for @areaTextInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Area is required'**
  String get areaTextInputRequired;

  /// No description provided for @jointSpacingInMeters.
  ///
  /// In en, this message translates to:
  /// **'Joint Spacing (S) in meters'**
  String get jointSpacingInMeters;

  /// No description provided for @jointSymbol.
  ///
  /// In en, this message translates to:
  /// **'J'**
  String get jointSymbol;

  /// No description provided for @jointSpacingSymbol.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get jointSpacingSymbol;

  /// No description provided for @jointVolume.
  ///
  /// In en, this message translates to:
  /// **'Joint Volume (Jv)'**
  String get jointVolume;

  /// No description provided for @numberOfRandomSetsSymbol.
  ///
  /// In en, this message translates to:
  /// **'Nr'**
  String get numberOfRandomSetsSymbol;

  /// No description provided for @areaSymbol.
  ///
  /// In en, this message translates to:
  /// **'A'**
  String get areaSymbol;

  /// No description provided for @rockQualityDesignationSymbol.
  ///
  /// In en, this message translates to:
  /// **'RQD'**
  String get rockQualityDesignationSymbol;

  /// No description provided for @jointVolumeSymbol.
  ///
  /// In en, this message translates to:
  /// **'Jv'**
  String get jointVolumeSymbol;

  /// No description provided for @rockQualityDesignationCalculation.
  ///
  /// In en, this message translates to:
  /// **'Rock Quality Designation Calculation (RQD):'**
  String get rockQualityDesignationCalculation;

  /// No description provided for @byUsingJointVolumeMethod.
  ///
  /// In en, this message translates to:
  /// **'By using Joint Volume Method'**
  String get byUsingJointVolumeMethod;

  /// No description provided for @byUsingDirectMethod.
  ///
  /// In en, this message translates to:
  /// **'By using Direct Method'**
  String get byUsingDirectMethod;

  /// No description provided for @rockQualityDesignation.
  ///
  /// In en, this message translates to:
  /// **'Rock Quality Designation (RQD)'**
  String get rockQualityDesignation;

  /// No description provided for @totalDrillRun.
  ///
  /// In en, this message translates to:
  /// **'Total Drill Run'**
  String get totalDrillRun;

  /// No description provided for @sumOfCorePieces.
  ///
  /// In en, this message translates to:
  /// **'Sum of Core Pieces'**
  String get sumOfCorePieces;

  /// No description provided for @numberOfJointsNotMoreThanHundred.
  ///
  /// In en, this message translates to:
  /// **'Number of Joints cannot be more than 100'**
  String get numberOfJointsNotMoreThanHundred;

  /// No description provided for @areaCannotBeZero.
  ///
  /// In en, this message translates to:
  /// **'Area should be more than zero'**
  String get areaCannotBeZero;

  /// No description provided for @nextPreviousButtonsNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextPreviousButtonsNext;

  /// No description provided for @nextPreviousButtonsPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get nextPreviousButtonsPrevious;

  /// No description provided for @jointRoughnessInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter joint roughness value for all the joints: (0.5 - 4)'**
  String get jointRoughnessInputTitle;

  /// No description provided for @jointAlterationInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter joint alteration value for all the joints: (0.75 - 20)'**
  String get jointAlterationInputTitle;

  /// No description provided for @jointRoughnessByValue.
  ///
  /// In en, this message translates to:
  /// **'By value'**
  String get jointRoughnessByValue;

  /// No description provided for @jointRoughnessByPalmstrom.
  ///
  /// In en, this message translates to:
  /// **'By Palmstrom method'**
  String get jointRoughnessByPalmstrom;

  /// No description provided for @jointRoughness.
  ///
  /// In en, this message translates to:
  /// **'Joint Roughness (Jr)'**
  String get jointRoughness;

  /// No description provided for @jointRoughnessWithLimits.
  ///
  /// In en, this message translates to:
  /// **'Joint Roughness (Jr) (0.5 - 4)'**
  String get jointRoughnessWithLimits;

  /// No description provided for @jointRoughnessSymbol.
  ///
  /// In en, this message translates to:
  /// **'Jr'**
  String get jointRoughnessSymbol;

  /// No description provided for @selectJointsHavingFailure.
  ///
  /// In en, this message translates to:
  /// **'Please select the joints having failure'**
  String get selectJointsHavingFailure;

  /// No description provided for @jointAlteration.
  ///
  /// In en, this message translates to:
  /// **'Joint Alteration (Ja)'**
  String get jointAlteration;

  /// No description provided for @jointAlterationSymbol.
  ///
  /// In en, this message translates to:
  /// **'Ja'**
  String get jointAlterationSymbol;

  /// No description provided for @jointWavyness.
  ///
  /// In en, this message translates to:
  /// **'Joint Wavyness (Jw)'**
  String get jointWavyness;

  /// No description provided for @jointSmoothness.
  ///
  /// In en, this message translates to:
  /// **'Joint Smoothness (Js)'**
  String get jointSmoothness;

  /// No description provided for @jointWavynessSymbol.
  ///
  /// In en, this message translates to:
  /// **'Jw'**
  String get jointWavynessSymbol;

  /// No description provided for @jointSmoothnessSymbol.
  ///
  /// In en, this message translates to:
  /// **'Js'**
  String get jointSmoothnessSymbol;

  /// No description provided for @accordingToBarAndBarton.
  ///
  /// In en, this message translates to:
  /// **'According to Bar & Barton (2017)'**
  String get accordingToBarAndBarton;

  /// No description provided for @jointRoughnessRequired.
  ///
  /// In en, this message translates to:
  /// **'Joint Roughness is required'**
  String get jointRoughnessRequired;

  /// No description provided for @jointRoughnessConstraintsValidation.
  ///
  /// In en, this message translates to:
  /// **'Joint Roughness should be a value between 0.5 and 4'**
  String get jointRoughnessConstraintsValidation;

  /// No description provided for @jointAlterationRequired.
  ///
  /// In en, this message translates to:
  /// **'Joint Alteration is required'**
  String get jointAlterationRequired;

  /// No description provided for @jointAlterationConstraintsValidation.
  ///
  /// In en, this message translates to:
  /// **'Joint Alteration should be a value between 0.75 and 20'**
  String get jointAlterationConstraintsValidation;

  /// No description provided for @jointRoughnessTable.
  ///
  /// In en, this message translates to:
  /// **'Joint Roughness Table'**
  String get jointRoughnessTable;

  /// No description provided for @jointAlterationTable.
  ///
  /// In en, this message translates to:
  /// **'Joint Alteration Table'**
  String get jointAlterationTable;

  /// No description provided for @oFactor.
  ///
  /// In en, this message translates to:
  /// **'O-Factor'**
  String get oFactor;

  /// No description provided for @oFactorConstraints.
  ///
  /// In en, this message translates to:
  /// **'(0.25 - 2)'**
  String get oFactorConstraints;

  /// No description provided for @oFactorCalculation.
  ///
  /// In en, this message translates to:
  /// **'O-Factor Calculation'**
  String get oFactorCalculation;

  /// No description provided for @enterOFactorsForTheJointsHavingFailures.
  ///
  /// In en, this message translates to:
  /// **'Enter O-Factor value for the joints having failures'**
  String get enterOFactorsForTheJointsHavingFailures;

  /// No description provided for @oFactorValueFor.
  ///
  /// In en, this message translates to:
  /// **'O-Factor Value for'**
  String get oFactorValueFor;

  /// No description provided for @oFactorValue.
  ///
  /// In en, this message translates to:
  /// **'O-Factor Value'**
  String get oFactorValue;

  /// No description provided for @oFactorValueInputConstraints.
  ///
  /// In en, this message translates to:
  /// **'O-Factor value should be between 0.25 and 2'**
  String get oFactorValueInputConstraints;

  /// No description provided for @oFactorByValue.
  ///
  /// In en, this message translates to:
  /// **'By value'**
  String get oFactorByValue;

  /// No description provided for @calculateRomanaAdjustmentFactor.
  ///
  /// In en, this message translates to:
  /// **'Calculate Romana\'s Adjustment Factor'**
  String get calculateRomanaAdjustmentFactor;

  /// No description provided for @romanaAdjustmentFactorByValue.
  ///
  /// In en, this message translates to:
  /// **'By value'**
  String get romanaAdjustmentFactorByValue;

  /// No description provided for @romanaAdjustmentFactorByF1F2F3.
  ///
  /// In en, this message translates to:
  /// **'By F1, F2, F3'**
  String get romanaAdjustmentFactorByF1F2F3;

  /// No description provided for @oFactorByRomanaAdjustmentFactor.
  ///
  /// In en, this message translates to:
  /// **'By using Romana\'s Adjustment Factors'**
  String get oFactorByRomanaAdjustmentFactor;

  /// No description provided for @discontinuityDipDirection.
  ///
  /// In en, this message translates to:
  /// **'Discontinuity Dip Direction'**
  String get discontinuityDipDirection;

  /// No description provided for @trendOfTheIntersectionLineInCaseOfTheWedge.
  ///
  /// In en, this message translates to:
  /// **'Trend of the Intersection Line in case of the Wedge'**
  String get trendOfTheIntersectionLineInCaseOfTheWedge;

  /// No description provided for @slopeDipDirection.
  ///
  /// In en, this message translates to:
  /// **'Slope Dip Direction'**
  String get slopeDipDirection;

  /// No description provided for @dipOfTheDiscontinuity.
  ///
  /// In en, this message translates to:
  /// **'Dip of the Discontinuity'**
  String get dipOfTheDiscontinuity;

  /// No description provided for @plungeOfTheIntersectionLine.
  ///
  /// In en, this message translates to:
  /// **'Plunge of the Intersection Line'**
  String get plungeOfTheIntersectionLine;

  /// No description provided for @dipOfTheSlope.
  ///
  /// In en, this message translates to:
  /// **'Dip of the Slope'**
  String get dipOfTheSlope;

  /// No description provided for @typeOfFailure.
  ///
  /// In en, this message translates to:
  /// **'Type of Failure'**
  String get typeOfFailure;

  /// No description provided for @romanaAdjustmentFactorSymbol.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get romanaAdjustmentFactorSymbol;

  /// No description provided for @alphaISymbol.
  ///
  /// In en, this message translates to:
  /// **'αi'**
  String get alphaISymbol;

  /// No description provided for @alphaJSymbol.
  ///
  /// In en, this message translates to:
  /// **'αj'**
  String get alphaJSymbol;

  /// No description provided for @alphaSSymbol.
  ///
  /// In en, this message translates to:
  /// **'αs'**
  String get alphaSSymbol;

  /// No description provided for @betaISymbol.
  ///
  /// In en, this message translates to:
  /// **'βi'**
  String get betaISymbol;

  /// No description provided for @betaJSymbol.
  ///
  /// In en, this message translates to:
  /// **'βj'**
  String get betaJSymbol;

  /// No description provided for @betaSSymbol.
  ///
  /// In en, this message translates to:
  /// **'βs'**
  String get betaSSymbol;

  /// No description provided for @isRequired.
  ///
  /// In en, this message translates to:
  /// **'is required'**
  String get isRequired;

  /// No description provided for @planarFailure.
  ///
  /// In en, this message translates to:
  /// **'Planar Failure'**
  String get planarFailure;

  /// No description provided for @wedgeFailure.
  ///
  /// In en, this message translates to:
  /// **'Wedge Failure'**
  String get wedgeFailure;

  /// No description provided for @ratingForF1.
  ///
  /// In en, this message translates to:
  /// **'Rating for F1'**
  String get ratingForF1;

  /// No description provided for @ratingForF2.
  ///
  /// In en, this message translates to:
  /// **'Rating for F2'**
  String get ratingForF2;

  /// No description provided for @ratingForF3.
  ///
  /// In en, this message translates to:
  /// **'Rating for F3'**
  String get ratingForF3;

  /// No description provided for @formulaForRatingForF1.
  ///
  /// In en, this message translates to:
  /// **'16/25 - (3/500 * atan(1/10 * (|F1| - 17)))'**
  String get formulaForRatingForF1;

  /// No description provided for @formulaForRatingForF2.
  ///
  /// In en, this message translates to:
  /// **'9/16 + (1/195 * atan((17/100 * F2) - 5))'**
  String get formulaForRatingForF2;

  /// No description provided for @formulaForRatingForF3ForTopplingFailure.
  ///
  /// In en, this message translates to:
  /// **'-13 - (1/7 * atan(F3 - 120))'**
  String get formulaForRatingForF3ForTopplingFailure;

  /// No description provided for @formulaForRatingForF3ForNonTopplingFailure.
  ///
  /// In en, this message translates to:
  /// **'-30 + (1/3 * atan(F3))'**
  String get formulaForRatingForF3ForNonTopplingFailure;

  /// No description provided for @atan.
  ///
  /// In en, this message translates to:
  /// **'atan'**
  String get atan;

  /// No description provided for @toppling.
  ///
  /// In en, this message translates to:
  /// **'Toppling'**
  String get toppling;

  /// No description provided for @valueOfF2.
  ///
  /// In en, this message translates to:
  /// **'Value of F2'**
  String get valueOfF2;

  /// No description provided for @jWiceCalculationBy.
  ///
  /// In en, this message translates to:
  /// **'Jwice Calculation By'**
  String get jWiceCalculationBy;

  /// No description provided for @jWiceCalculationByValue.
  ///
  /// In en, this message translates to:
  /// **'By value'**
  String get jWiceCalculationByValue;

  /// No description provided for @jWiceCalculcationByExternalFactors.
  ///
  /// In en, this message translates to:
  /// **'By External Factors'**
  String get jWiceCalculcationByExternalFactors;

  /// No description provided for @enviornmentalAndGeologicalConditionalNumber.
  ///
  /// In en, this message translates to:
  /// **'Environmental and Geological Conditional Number (Jwice) (0.05 - 1)'**
  String get enviornmentalAndGeologicalConditionalNumber;

  /// No description provided for @enviornmentalAndGeologicalConditionalNumberSymbol.
  ///
  /// In en, this message translates to:
  /// **'Jwice'**
  String get enviornmentalAndGeologicalConditionalNumberSymbol;

  /// No description provided for @jWiceInputConstraints.
  ///
  /// In en, this message translates to:
  /// **'Jwice value should be between 0.05 and 1'**
  String get jWiceInputConstraints;

  /// No description provided for @externalFactorStructure.
  ///
  /// In en, this message translates to:
  /// **'Structure'**
  String get externalFactorStructure;

  /// No description provided for @structureStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get structureStable;

  /// No description provided for @structureUnstable.
  ///
  /// In en, this message translates to:
  /// **'Unstable'**
  String get structureUnstable;

  /// No description provided for @strengthOfRock.
  ///
  /// In en, this message translates to:
  /// **'Strength of Rock'**
  String get strengthOfRock;

  /// No description provided for @strengthOfRockCompetent.
  ///
  /// In en, this message translates to:
  /// **'Competent'**
  String get strengthOfRockCompetent;

  /// No description provided for @strengthOfRockCompetentNote.
  ///
  /// In en, this message translates to:
  /// **'Note: Rocks having UCS more than 50 MPa are considered as competent'**
  String get strengthOfRockCompetentNote;

  /// No description provided for @strengthOfRockInCompetent.
  ///
  /// In en, this message translates to:
  /// **'Incompetent'**
  String get strengthOfRockInCompetent;

  /// No description provided for @environmentalConditions.
  ///
  /// In en, this message translates to:
  /// **'Environmental Conditions'**
  String get environmentalConditions;

  /// No description provided for @desertEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Desert Environment'**
  String get desertEnvironment;

  /// No description provided for @wetEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Wet Environment'**
  String get wetEnvironment;

  /// No description provided for @tropicalStorms.
  ///
  /// In en, this message translates to:
  /// **'Tropical Storms'**
  String get tropicalStorms;

  /// No description provided for @iceWedging.
  ///
  /// In en, this message translates to:
  /// **'Ice Wedging'**
  String get iceWedging;

  /// No description provided for @stressReductionFactor.
  ///
  /// In en, this message translates to:
  /// **'Stress Reduction Factor (SRF)'**
  String get stressReductionFactor;

  /// No description provided for @stressReductionFactorSymbol.
  ///
  /// In en, this message translates to:
  /// **'SRF'**
  String get stressReductionFactorSymbol;

  /// No description provided for @srfA.
  ///
  /// In en, this message translates to:
  /// **'SRFa'**
  String get srfA;

  /// No description provided for @srfB.
  ///
  /// In en, this message translates to:
  /// **'SRFb'**
  String get srfB;

  /// No description provided for @srfC.
  ///
  /// In en, this message translates to:
  /// **'SRFc'**
  String get srfC;

  /// No description provided for @srfAInputTitle.
  ///
  /// In en, this message translates to:
  /// **'SRFa (0 - 20)'**
  String get srfAInputTitle;

  /// No description provided for @srfBInputTitle.
  ///
  /// In en, this message translates to:
  /// **'SRFb (1 - 200)'**
  String get srfBInputTitle;

  /// No description provided for @srfCInputTitle.
  ///
  /// In en, this message translates to:
  /// **'SRFc (1 - 24)'**
  String get srfCInputTitle;

  /// No description provided for @maxOf.
  ///
  /// In en, this message translates to:
  /// **'Maximum of'**
  String get maxOf;

  /// No description provided for @qSlopeSymbol.
  ///
  /// In en, this message translates to:
  /// **'Q-slope'**
  String get qSlopeSymbol;

  /// No description provided for @qSlopeCalculation.
  ///
  /// In en, this message translates to:
  /// **'Q-slope Calculation'**
  String get qSlopeCalculation;

  /// No description provided for @srfAInputConstraints.
  ///
  /// In en, this message translates to:
  /// **'SRFa value should be between 0 and 20'**
  String get srfAInputConstraints;

  /// No description provided for @srfBInputConstraints.
  ///
  /// In en, this message translates to:
  /// **'SRFb value should be between 1 and 200'**
  String get srfBInputConstraints;

  /// No description provided for @srfCInputConstraints.
  ///
  /// In en, this message translates to:
  /// **'SRFc value should be between 1 and 24'**
  String get srfCInputConstraints;

  /// No description provided for @activeStress.
  ///
  /// In en, this message translates to:
  /// **'Active Stress'**
  String get activeStress;

  /// No description provided for @errorInSavingCalculation.
  ///
  /// In en, this message translates to:
  /// **'Error in saving calculation'**
  String get errorInSavingCalculation;

  /// No description provided for @errorInDeletingCalculation.
  ///
  /// In en, this message translates to:
  /// **'Error in deleting calculation'**
  String get errorInDeletingCalculation;

  /// No description provided for @saveCalculationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Calculation saved'**
  String get saveCalculationSuccessful;

  /// No description provided for @deleteCalculationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Calculation deleted'**
  String get deleteCalculationSuccessful;

  /// No description provided for @listLocationId.
  ///
  /// In en, this message translates to:
  /// **'Location Id'**
  String get listLocationId;

  /// No description provided for @listLithology.
  ///
  /// In en, this message translates to:
  /// **'Lithology'**
  String get listLithology;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @proudlyBuiltInIndia.
  ///
  /// In en, this message translates to:
  /// **'Proudly built in India'**
  String get proudlyBuiltInIndia;

  /// No description provided for @aboutQSlope.
  ///
  /// In en, this message translates to:
  /// **'About Q-slope'**
  String get aboutQSlope;

  /// No description provided for @references.
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get references;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @aboutQSlopeInfo.
  ///
  /// In en, this message translates to:
  /// **'Q-slope is an empirical rock slope engineering method for assessing the stability of excavated rock slopes in the field. Intended for use in reinforcement-free road or railway cuttings or in opencast mines, Q-slope allows geotechnical engineers to make potential adjustments to slope angles as rock mass conditions become apparent during construction.'**
  String get aboutQSlopeInfo;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @completeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Caution!'**
  String get completeDialogTitle;

  /// No description provided for @pleaseCompleteBlockSizeSection.
  ///
  /// In en, this message translates to:
  /// **'Please complete the Basic Info and Block Size section before proceeding to this step.'**
  String get pleaseCompleteBlockSizeSection;

  /// No description provided for @exportFileTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Excel File'**
  String get exportFileTitle;

  /// No description provided for @exportFileContent.
  ///
  /// In en, this message translates to:
  /// **'Do you want to export calculations as an excel file?'**
  String get exportFileContent;

  /// No description provided for @exportSuccessful.
  ///
  /// In en, this message translates to:
  /// **'File exported successfully as {fileName}'**
  String exportSuccessful(Object fileName);

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'File export failed'**
  String get exportFailed;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteCalculationsModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Calculations'**
  String get deleteCalculationsModalTitle;

  /// No description provided for @deleteCalculationsModalContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to delete the selected calculations?'**
  String get deleteCalculationsModalContent;

  /// No description provided for @errorInLoadingQSlopeList.
  ///
  /// In en, this message translates to:
  /// **'Error in loading Q-slope list. Please try removing app data or re-installing the app'**
  String get errorInLoadingQSlopeList;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @selectDirectoryToSaveFile.
  ///
  /// In en, this message translates to:
  /// **'Please select a directory to save the file'**
  String get selectDirectoryToSaveFile;

  /// No description provided for @qSlopeStabilityChart.
  ///
  /// In en, this message translates to:
  /// **'Q-slope Stability Chart'**
  String get qSlopeStabilityChart;

  /// No description provided for @stabilityChart.
  ///
  /// In en, this message translates to:
  /// **'Stability Chart'**
  String get stabilityChart;

  /// No description provided for @unstableSlopes.
  ///
  /// In en, this message translates to:
  /// **'Unstable Slopes'**
  String get unstableSlopes;

  /// No description provided for @slopeStabilityUncertain.
  ///
  /// In en, this message translates to:
  /// **'Slope Stability Uncertain'**
  String get slopeStabilityUncertain;

  /// No description provided for @stableSlopes.
  ///
  /// In en, this message translates to:
  /// **'Stable Slopes'**
  String get stableSlopes;

  /// No description provided for @stabilityChartYAxisTitle.
  ///
  /// In en, this message translates to:
  /// **'Slope Angle, β (degrees)'**
  String get stabilityChartYAxisTitle;

  /// No description provided for @stabilityChartXAxisTitle.
  ///
  /// In en, this message translates to:
  /// **'Q-slope'**
  String get stabilityChartXAxisTitle;

  /// No description provided for @lineOfBestFitForStableSlopes.
  ///
  /// In en, this message translates to:
  /// **'Line of Best Fit for Stable Slopes'**
  String get lineOfBestFitForStableSlopes;

  /// No description provided for @logbase10.
  ///
  /// In en, this message translates to:
  /// **'log base 10'**
  String get logbase10;

  /// No description provided for @slopeAngleQSlopeFormula.
  ///
  /// In en, this message translates to:
  /// **'Slope Angle β (degrees) = 20 x log(Q-slope) + 65°'**
  String get slopeAngleQSlopeFormula;

  /// No description provided for @slopeAngleSymbol.
  ///
  /// In en, this message translates to:
  /// **'β'**
  String get slopeAngleSymbol;

  /// No description provided for @slopeAngleProvidedByUserSymbol.
  ///
  /// In en, this message translates to:
  /// **'α'**
  String get slopeAngleProvidedByUserSymbol;

  /// No description provided for @chartPointAnnotation.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get chartPointAnnotation;

  /// No description provided for @degreesSymbol.
  ///
  /// In en, this message translates to:
  /// **'°'**
  String get degreesSymbol;

  /// No description provided for @slopeStabilityUncertainChartAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Slope\nStability\nUncertain'**
  String get slopeStabilityUncertainChartAreaLabel;

  /// No description provided for @slopeAngleByUser.
  ///
  /// In en, this message translates to:
  /// **'Slope Angle (α) in degrees'**
  String get slopeAngleByUser;

  /// No description provided for @slopeAngleProvidedAsInput.
  ///
  /// In en, this message translates to:
  /// **'Slope Angle Provided as Input (α) in degrees'**
  String get slopeAngleProvidedAsInput;

  /// No description provided for @point.
  ///
  /// In en, this message translates to:
  /// **'Point'**
  String get point;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not Provided'**
  String get notProvided;

  /// No description provided for @exportChart.
  ///
  /// In en, this message translates to:
  /// **'Export Chart'**
  String get exportChart;

  /// No description provided for @chartExportSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Chart exported successfully as {fileName}'**
  String chartExportSuccessful(Object fileName);

  /// No description provided for @chartExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Chart export failed'**
  String get chartExportFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
