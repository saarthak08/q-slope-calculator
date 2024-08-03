import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/screens/about_screen/about_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/illustration_widget.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';
import 'package:q_slope_calculator/src/utils/custom_progress_indicator.dart';
import 'package:q_slope_calculator/src/utils/date_time_utils.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<QSlopeListCubit>().loadQSlopeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: [
              Padding(
                  padding: EdgeInsets.all(getViewPortHeight(context) * 0.01),
                  child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal, width: 1),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Navigator.pushNamed(context, AboutScreen.route);
                          },
                          child: Image.asset(
                            Assets.pngIcon,
                          ))))
            ],
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).appName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashColor: Colors.teal.withOpacity(0.2),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.add,
                color: Colors.teal,
              ),
              SizedBox(
                width: getViewPortWidth(context) * 0.02,
              ),
              Text(
                AppLocalizations.of(context).homeScreenCalculateButtonText,
                style: const TextStyle(color: Colors.teal),
              ),
            ],
          ),
          backgroundColor: white,
          onPressed: () {
            Navigator.pushNamed(context, CalculateScreen.route,
                arguments: CalculateScreenArguments(qSlope: null));
          },
        ),
        body: BlocBuilder<QSlopeListCubit, QSlopeListState>(
            bloc: BlocProvider.of<QSlopeListCubit>(context),
            builder: (context, state) => state is QSlopeListEmpty
                ? Center(
                    child: IllustrationWidget(
                        assetPath: Assets.noData,
                        text: AppLocalizations.of(context)
                            .homeScreenNoPreviousCalculationsFound,
                        onRefresh: null))
                : state is QSlopeListLoaded
                    ? Container(
                        padding: EdgeInsets.only(
                            right: getViewPortWidth(context) * 0.02,
                            left: getViewPortWidth(context) * 0.02,
                            bottom: getViewPortHeight(context) * 0.01,
                            top: getViewPortHeight(context) * 0.01),
                        child: ListView.builder(
                            itemCount: state.qSlopeList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: EdgeInsets.only(
                                      top: getViewPortHeight(context) * 0.015),
                                  child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      borderOnForeground: true,
                                      type: MaterialType.card,
                                      elevation: 0.5,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, CalculateScreen.route,
                                              arguments:
                                                  CalculateScreenArguments(
                                                      qSlope: state
                                                          .qSlopeList[index]
                                                          .copyWith()));
                                        },
                                        title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${AppLocalizations.of(context).listLocationId}: ${state.qSlopeList[index].locationId}"),
                                              Text(
                                                  "${AppLocalizations.of(context).listLithology}: ${state.qSlopeList[index].lithology}")
                                            ]),
                                        subtitle: Container(
                                            margin: EdgeInsets.only(
                                                top:
                                                    getViewPortHeight(context) *
                                                        0.01),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${AppLocalizations.of(context).qSlopeSymbol}: ${state.qSlopeList[index].qSlope?.toStringAsFixed(4)}"),
                                                  Text(
                                                      "${AppLocalizations.of(context).createdAt}: ${state.qSlopeList[index].createdAt != null ? formatDateTime(state.qSlopeList[index].createdAt!) : ""}")
                                                ])),
                                      )));
                            }))
                    : const Center(child: CustomProgressIndicator())));
  }
}
