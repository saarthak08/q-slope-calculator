import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/dialogs/full_screen_loader_dialog.dart';
import 'package:q_slope_calculator/src/ui/dialogs/generic_dialog.dart';
import 'package:q_slope_calculator/src/ui/screens/about_screen/about_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/widgets/illustration_widget.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';
import 'package:q_slope_calculator/src/utils/custom_progress_indicator.dart';
import 'package:q_slope_calculator/src/utils/date_time_utils.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:q_slope_calculator/src/utils/export_excel_file.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late QSlopeListState qSlopeListState;
  List<bool>? _selectedTiles = List.empty(growable: true);

  @override
  void initState() {
    context.read<QSlopeListCubit>().loadQSlopeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    qSlopeListState = context.watch<QSlopeListCubit>().state;
    var qSlopeState = qSlopeListState;
    if (qSlopeState is QSlopeListLoaded) {
      int length = qSlopeState.qSlopeList.length;
      if (_selectedTiles == null ||
          _selectedTiles!.isEmpty ||
          _selectedTiles!.length != qSlopeState.qSlopeList.length) {
        setState(() {
          _selectedTiles = List.filled(length, false);
        });
      }
    }
    return Scaffold(
        appBar: AppBar(
            actions: [
              _selectedTiles?.firstWhereOrNull((val) => val) != null
                  ? Container(
                      margin: EdgeInsets.only(
                          right: getViewPortWidth(context) * 0.005),
                      child: InkWell(
                        onTap: () {
                          showGenericDialog(
                              context: context,
                              titleText:
                                  AppLocalizations.of(context).exportFileTitle,
                              label: AppLocalizations.of(context)
                                  .exportFileContent,
                              onOk: () async {
                                var selectedTiles = _selectedTiles;
                                var qSlopeState = qSlopeListState;
                                if (qSlopeState is QSlopeListLoaded &&
                                    selectedTiles != null) {
                                  int index = 0;
                                  var qSlopes =
                                      List<QSlope>.empty(growable: true);
                                  for (var selectedQSlopes in selectedTiles) {
                                    if (selectedQSlopes) {
                                      qSlopes
                                          .add(qSlopeState.qSlopeList[index]);
                                    }
                                    index++;
                                  }
                                  showFullScreenLoader(context);
                                  try {
                                    String fileName =
                                        await exportExcelFile(qSlopes, context);
                                    if (context.mounted) {
                                      toastification.show(
                                          autoCloseDuration:
                                              const Duration(seconds: 2),
                                          alignment: Alignment.bottomCenter,
                                          type: ToastificationType.success,
                                          title: Text(
                                              AppLocalizations.of(context)
                                                  .exportSuccessful(fileName)));
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  } catch (err) {
                                    if (context.mounted) {
                                      toastification.show(
                                          autoCloseDuration:
                                              const Duration(seconds: 2),
                                          alignment: Alignment.bottomCenter,
                                          type: ToastificationType.error,
                                          title: Text(
                                              AppLocalizations.of(context)
                                                  .exportFailed));
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                      }
                                      rethrow;
                                    }
                                  }
                                  setState(() {
                                    _selectedTiles = List.filled(
                                        qSlopeState.qSlopeList.length, false);
                                  });
                                }
                              });
                        },
                        child: Icon(
                          Icons.file_upload_outlined,
                          color: primaryColor,
                          size: getBodyFontSize(context) * 2,
                        ),
                      ))
                  : Container(),
              Padding(
                  padding: EdgeInsets.all(getViewPortHeight(context) * 0.01),
                  child: Ink(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 1.5),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: () {
                            Navigator.pushNamed(context, AboutScreen.route);
                          },
                          child: Image.asset(
                            Assets.pngIcon,
                            scale: getBodyFontSize(context) * 2,
                          ))))
            ],
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).appName,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getTitleFontSize(context)),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashColor: primaryColor.withOpacity(0.2),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: primaryColor,
              ),
              SizedBox(
                width: getViewPortWidth(context) * 0.02,
              ),
              Text(
                AppLocalizations.of(context).homeScreenCalculateButtonText,
                style: TextStyle(color: primaryColor),
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
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        _selectedTiles?.firstWhereOrNull(
                                                    (val) => val) !=
                                                null
                                            ? Container(
                                                margin: EdgeInsets.only(
                                                    right: getViewPortWidth(
                                                            context) *
                                                        0.005),
                                                child: Checkbox(
                                                    value: (_selectedTiles
                                                                    ?.length ??
                                                                0) >
                                                            index
                                                        ? (_selectedTiles?[
                                                                index] ??
                                                            false)
                                                        : false,
                                                    onChanged: (value) {
                                                      _selectedTiles?[index] =
                                                          value ?? false;
                                                      setState(() {
                                                        _selectedTiles =
                                                            List.from(
                                                                _selectedTiles ??
                                                                    []);
                                                      });
                                                    }))
                                            : Container(),
                                        Expanded(
                                            child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                borderOnForeground: true,
                                                type: MaterialType.card,
                                                elevation: 0.5,
                                                child: ListTile(
                                                  onLongPress: () {
                                                    _selectedTiles?[index] =
                                                        (!(_selectedTiles?[
                                                                index] ??
                                                            true));
                                                    setState(() {
                                                      _selectedTiles =
                                                          List.from(
                                                              _selectedTiles ??
                                                                  []);
                                                    });
                                                  },
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        CalculateScreen.route,
                                                        arguments:
                                                            CalculateScreenArguments(
                                                                qSlope: state
                                                                    .qSlopeList[
                                                                        index]
                                                                    .copyWith()));
                                                  },
                                                  title: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "${AppLocalizations.of(context).listLocationId}: ${state.qSlopeList[index].locationId}"),
                                                        Text(
                                                            "${AppLocalizations.of(context).listLithology}: ${state.qSlopeList[index].lithology}")
                                                      ]),
                                                  subtitle: Container(
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              getViewPortHeight(
                                                                      context) *
                                                                  0.01),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "${AppLocalizations.of(context).qSlopeSymbol}: ${state.qSlopeList[index].qSlope?.toStringAsFixed(4)}"),
                                                            Text(
                                                                "${AppLocalizations.of(context).createdAt}: ${state.qSlopeList[index].createdAt != null ? formatDateTime(state.qSlopeList[index].createdAt!) : ""}")
                                                          ])),
                                                )))
                                      ]));
                            }))
                    : const Center(child: CustomProgressIndicator())));
  }
}
