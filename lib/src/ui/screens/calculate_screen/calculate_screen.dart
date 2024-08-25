import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/data/common/qslope_error.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/dialogs/generic_dialog.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/active_stress_page/active_stress_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/block_size_page/block_size_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/external_factors_page/external_factors_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/joint_character_page/joint_character_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/o_factor_page/o_factor_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/tab_widget.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

class CalculateScreen extends StatefulWidget {
  static const String route = '/calculate';
  final QSlope? qSlope;

  const CalculateScreen({super.key, this.qSlope});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<QSlope> _qSlope;
  late ValueNotifier<List<bool>> _errorTabs;
  TabController? _tabController;
  final uuid = const Uuid();

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    _tabController?.addListener(() {
      if (_tabController!.indexIsChanging &&
          (_tabController!.index == 1 || _tabController!.index == 2)) {
        QSlope qSlope = _qSlope.value;
        if (qSlope.blockSize == null ||
            qSlope.blockSize!.jointSetNumber == null ||
            qSlope.blockSize!.numberOfJoints == null ||
            qSlope.blockSize!.numberOfRandomSets == null ||
            qSlope.blockSize!.rqd == null) {
          showGenericDialog(
              titleText: AppLocalizations.of(context).completeDialogTitle,
              context: context,
              label:
                  AppLocalizations.of(context).pleaseCompleteBlockSizeSection,
              barrierDismissable: false,
              hideCancel: true,
              onOk: () async {
                _tabController?.animateTo(0, curve: Curves.easeIn);
                Navigator.pop(context);
              });
        }
      }
    });
    _qSlope = ValueNotifier(widget.qSlope ?? QSlope(id: uuid.v4()));
    _errorTabs = ValueNotifier(List.filled(5, widget.qSlope == null));
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
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
          AppLocalizations.of(context).qSlopeCalculation,
          style: TextStyle(fontSize: getTitleFontSize(context)),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
        bottom: TabBar(
            dividerColor: primaryColorShade100,
            controller: _tabController,
            tabAlignment: ResponsiveBreakpoints.of(context).screenWidth < 700
                ? TabAlignment.start
                : null,
            isScrollable: ResponsiveBreakpoints.of(context).screenWidth < 700,
            tabs: [
              TabWidget(
                  errorTabs: _errorTabs,
                  tabText:
                      AppLocalizations.of(context).blockSizePageAppBarTitle,
                  tabBarIndex: 0),
              TabWidget(
                  errorTabs: _errorTabs,
                  tabText:
                      AppLocalizations.of(context).joinCharacterPageAppBarTitle,
                  tabBarIndex: 1),
              TabWidget(
                  errorTabs: _errorTabs,
                  tabText: AppLocalizations.of(context).oFactorPageAppBarTitle,
                  tabBarIndex: 2),
              TabWidget(
                  errorTabs: _errorTabs,
                  tabText: AppLocalizations.of(context)
                      .externalFactorsPageAppBarTitle,
                  tabBarIndex: 3),
              TabWidget(
                  errorTabs: _errorTabs,
                  tabText:
                      AppLocalizations.of(context).activeStressPageAppBarTitle,
                  tabBarIndex: 4),
            ]),
        elevation: 1,
        shadowColor: Colors.white,
        actions: [
          widget.qSlope != null
              ? IconButton(
                  onPressed: () async {
                    final QSlope qSlope = _qSlope.value;
                    var result = await context
                        .read<QSlopeListCubit>()
                        .deleteQSlopeFromList(qSlope.id);
                    if (result.isSuccess && buildContext.mounted) {
                      toastification.show(
                          autoCloseDuration: const Duration(seconds: 2),
                          alignment: Alignment.bottomCenter,
                          type: ToastificationType.success,
                          title: Text(AppLocalizations.of(buildContext)
                              .deleteCalculationSuccessful));
                      Navigator.pop(buildContext);
                      if (result.isFailure &&
                          result.error is QSlopeError &&
                          buildContext.mounted) {
                        toastification.show(
                            autoCloseDuration: const Duration(seconds: 2),
                            alignment: Alignment.bottomCenter,
                            type: ToastificationType.error,
                            title: Text(AppLocalizations.of(buildContext)
                                .errorInDeletingCalculation));
                      }
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: primaryColor,
                  ))
              : Container(),
        ],
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          BlockSizePage(
            errorTabs: _errorTabs,
            qSlope: _qSlope,
          ),
          JointCharacterPage(
            qSlope: _qSlope,
            errorTabs: _errorTabs,
          ),
          OFactorPage(
            qSlope: _qSlope,
            errorTabs: _errorTabs,
          ),
          ExternalFactorsPage(
            qSlope: _qSlope,
            errorTabs: _errorTabs,
          ),
          ActiveStressPage(
            qSlope: _qSlope,
            errorTabs: _errorTabs,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _qSlope.dispose();
    super.dispose();
  }
}

class CalculateScreenArguments {
  final QSlope? qSlope;

  CalculateScreenArguments({required this.qSlope});
}
