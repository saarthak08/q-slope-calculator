import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/data/common/qslope_error.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/active_stress_page/active_stress_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/block_size_page/block_size_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/external_factors_page/external_factors_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/joint_roughness_page/joint_roughness_page.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/components/o_factor_page/o_factor_page.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:toastification/toastification.dart';

class CalculateScreen extends StatefulWidget {
  static const String route = '/calculate';
  final QSlope? qSlope;

  const CalculateScreen({super.key, this.qSlope});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  final ValueNotifier<int> page = ValueNotifier(0);
  final PageController _pageController = PageController();
  late ValueNotifier<QSlope?> _qSlope;
  final int maxPageValue = 4;

  String getAppBarTitle(int pageValue) {
    switch (pageValue) {
      case 0:
        return AppLocalizations.of(context).blockSizePageAppBarTitle;
      case 1:
        return AppLocalizations.of(context).joinCharacterPageAppBarTitle;
      case 2:
        return AppLocalizations.of(context).oFactorPageAppBarTitle;
      case 3:
        return AppLocalizations.of(context).externalFactorsPageAppBarTitle;
      case 4:
        return AppLocalizations.of(context).activeStressPageAppBarTitle;
      default:
        return "";
    }
  }

  @override
  void initState() {
    _qSlope = ValueNotifier(widget.qSlope);
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.teal,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: ValueListenableBuilder<int>(
              valueListenable: page,
              builder: (context, value, child) => Text(
                    getAppBarTitle(value),
                    style: TextStyle(fontSize: getTitleFontSize(context)),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  )),
          elevation: 1,
          shadowColor: Colors.white,
          actions: [
            widget.qSlope != null
                ? IconButton(
                    onPressed: () async {
                      final QSlope? qSlope = _qSlope.value;
                      if (qSlope != null) {
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
                        }
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
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.teal,
                    ))
                : Container(),
          ],
        ),
        body: Stack(children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              BlockSizePage(
                pageController: _pageController,
                qSlope: _qSlope,
                currentPage: page,
                maxPageValue: maxPageValue,
              ),
              JointRoughnessPage(
                  qSlope: _qSlope,
                  pageController: _pageController,
                  currentPage: page,
                  maxPageValue: maxPageValue),
              OFactorPage(
                  qSlope: _qSlope,
                  pageController: _pageController,
                  currentPage: page,
                  maxPageValue: maxPageValue),
              ExternalFactorsPage(
                  qSlope: _qSlope,
                  pageController: _pageController,
                  currentPage: page,
                  maxPageValue: maxPageValue),
              ActiveStressPage(
                  qSlope: _qSlope,
                  pageController: _pageController,
                  currentPage: page,
                  maxPageValue: maxPageValue),
            ],
          ),
        ]));
  }

  @override
  void dispose() {
    _pageController.dispose();
    page.dispose();
    _qSlope.dispose();
    super.dispose();
  }
}

class CalculateScreenArguments {
  final QSlope? qSlope;

  CalculateScreenArguments({required this.qSlope});
}
