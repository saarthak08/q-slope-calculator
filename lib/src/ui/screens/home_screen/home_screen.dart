import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/l10n/generated/app_localizations.dart';
import 'package:q_slope_calculator/src/constants/assets.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/repository/q_slope_repository.dart';
import 'package:q_slope_calculator/src/logic/cubit/q_slope_list/q_slope_list_cubit.dart';
import 'package:q_slope_calculator/src/ui/dialogs/full_screen_loader_dialog.dart';
import 'package:q_slope_calculator/src/ui/screens/calculate_screen/calculate_screen.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/components/app_bar_list_selection_menu_widget.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/components/home_app_bar_overflow_menu.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/components/home_empty_filter_view.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/components/home_search_and_filter_bar.dart';
import 'package:q_slope_calculator/src/ui/screens/home_screen/components/q_slope_list_item_card.dart';
import 'package:q_slope_calculator/src/ui/widgets/custom_progress_indicator.dart';
import 'package:q_slope_calculator/src/ui/widgets/illustration_widget.dart';
import 'package:q_slope_calculator/src/utils/color_pallet.dart';
import 'package:q_slope_calculator/src/utils/csv_utils.dart';
import 'package:q_slope_calculator/src/utils/dimensions.dart';
import 'package:q_slope_calculator/src/utils/formulas.dart';
import 'package:q_slope_calculator/src/utils/theme/font_sizes.dart';
import 'package:q_slope_calculator/src/utils/theme/theme_data.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  SlopeStabilityStatus? _selectedStatusFilter;
  QSlopeSortOption _selectedSortOption = QSlopeSortOption.dateNewest;
  Set<String> _selectedIds = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    context.read<QSlopeListCubit>().loadQSlopeList();
    _searchFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _setSelectedIds(Set<String> setIds) {
    setState(() {
      _selectedIds = setIds;
      if (_selectedIds.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedIds.clear();
    });
  }

  List<QSlope> _filterAndSortList(List<QSlope> originalList) {
    List<QSlope> filtered =
        originalList.where((item) {
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            final loc = (item.locationId ?? '').toLowerCase();
            final lith = (item.lithology ?? '').toLowerCase();
            if (!loc.contains(query) && !lith.contains(query)) {
              return false;
            }
          }
          if (_selectedStatusFilter != null) {
            final status = getSlopeStabilityStatus(
              item.qSlope,
              item.slopeAngleByUser,
            );
            if (status != _selectedStatusFilter) {
              return false;
            }
          }
          return true;
        }).toList();

    switch (_selectedSortOption) {
      case QSlopeSortOption.dateNewest:
        filtered.sort(
          (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
            a.createdAt ?? DateTime(0),
          ),
        );
        break;
      case QSlopeSortOption.dateOldest:
        filtered.sort(
          (a, b) => (a.createdAt ?? DateTime(0)).compareTo(
            b.createdAt ?? DateTime(0),
          ),
        );
        break;
      case QSlopeSortOption.qSlopeHigh:
        filtered.sort((a, b) => (b.qSlope ?? 0).compareTo(a.qSlope ?? 0));
        break;
      case QSlopeSortOption.qSlopeLow:
        filtered.sort((a, b) => (a.qSlope ?? 0).compareTo(b.qSlope ?? 0));
        break;
      case QSlopeSortOption.locationAZ:
        filtered.sort(
          (a, b) => (a.locationId ?? '').toLowerCase().compareTo(
            (b.locationId ?? '').toLowerCase(),
          ),
        );
        break;
      case QSlopeSortOption.locationZA:
        filtered.sort(
          (a, b) => (b.locationId ?? '').toLowerCase().compareTo(
            (a.locationId ?? '').toLowerCase(),
          ),
        );
        break;
    }

    return filtered;
  }

  Future<void> _handleImport(BuildContext context) async {
    try {
      final items = await CsvUtils.pickAndParseCsv();

      if (items == null || items.isEmpty) return;

      if (!context.mounted) return;
      final cubit = context.read<QSlopeListCubit>();
      final state = cubit.state;
      List<QSlope> existing = [];
      if (state is QSlopeListLoaded) {
        existing = state.qSlopeList;
      }
      final existingIds = existing.map((e) => e.id).toSet();
      final hasConflicts = items.any((e) => existingIds.contains(e.id));

      ImportConflictStrategy strategy = ImportConflictStrategy.overwrite;
      if (hasConflicts && context.mounted) {
        final selectedStrategy = await showDialog<ImportConflictStrategy>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                title: Text(AppLocalizations.of(ctx).importConflictTitle),
                content: Text(AppLocalizations.of(ctx).importConflictContent),
                actions: [
                  TextButton(
                    onPressed:
                        () => Navigator.pop(ctx, ImportConflictStrategy.skip),
                    child: Text(AppLocalizations.of(ctx).skipDuplicates),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.pop(
                          ctx,
                          ImportConflictStrategy.overwrite,
                        ),
                    child: Text(AppLocalizations.of(ctx).overwriteExisting),
                  ),
                  TextButton(
                    onPressed:
                        () => Navigator.pop(
                          ctx,
                          ImportConflictStrategy.importAsNew,
                        ),
                    child: Text(AppLocalizations.of(ctx).importAsNew),
                  ),
                ],
              ),
        );
        if (selectedStrategy == null) return;
        strategy = selectedStrategy;
      }

      if (!context.mounted) return;
      showFullScreenLoader(context);
      final result = await cubit.importQSlopes(items, strategy: strategy);
      if (!context.mounted) return;
      Navigator.pop(context);

      if (result.isSuccess) {
        final count = result.value ?? items.length;
        toastification.show(
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.success,
          title: Text(AppLocalizations.of(context).importSuccessful(count)),
        );
      } else {
        toastification.show(
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.error,
          title: Text(
            AppLocalizations.of(
              context,
            ).importFailed(AppLocalizations.of(context).saveFailed),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        toastification.show(
          autoCloseDuration: const Duration(seconds: 2),
          alignment: Alignment.bottomCenter,
          type: ToastificationType.error,
          title: Text(AppLocalizations.of(context).importFailed(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final qSlopeListState = context.watch<QSlopeListCubit>().state;
    List<QSlope> rawList = [];
    if (qSlopeListState is QSlopeListLoaded) {
      rawList = qSlopeListState.qSlopeList;
    }
    final filteredList = _filterAndSortList(rawList);
    final bool isSelectionActive =
        (_isSelectionMode || _selectedIds.isNotEmpty) && rawList.isNotEmpty;

    return PopScope(
      canPop: !_searchFocusNode.hasFocus && !isSelectionActive,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        } else if (isSelectionActive) {
          setState(() {
            _isSelectionMode = false;
            _selectedIds.clear();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading:
              isSelectionActive
                  ? IconButton(
                    icon: const Icon(Icons.close),
                    color: primaryColor,
                    onPressed: () {
                      setState(() {
                        _isSelectionMode = false;
                        _selectedIds.clear();
                      });
                    },
                  )
                  : Padding(
                    padding: EdgeInsets.all(getViewPortHeight(context) * 0.01),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColor, width: 1.5),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        Assets.pngIcon,
                        scale: getBodyFontSize(context) * 2,
                      ),
                    ),
                  ),
          actions: [
            if (isSelectionActive)
              AppBarListSelectionMenuWidget(
                selectedIds: _selectedIds,
                currentList: filteredList,
                setSelectedIds: _setSelectedIds,
                onExitSelectionMode: _exitSelectionMode,
              )
            else
              HomeAppBarOverflowMenu(
                allQSlopes: rawList,
                onImport: _handleImport,
                onBulkSelect: () {
                  setState(() {
                    _isSelectionMode = true;
                  });
                },
              ),
          ],
          title:
              isSelectionActive
                  ? FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(
                        context,
                      ).selectedCount(_selectedIds.length),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getSubTitleFontSize(context),
                        color: primaryColor,
                      ),
                    ),
                  )
                  : FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context).appName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: getTitleFontSize(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          splashColor: primaryColor.withValues(alpha: 0.2),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add, color: primaryColor),
              SizedBox(width: getViewPortWidth(context) * 0.02),
              Text(
                AppLocalizations.of(context).homeScreenCalculateButtonText,
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
          backgroundColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : white,
          onPressed: () {
            Navigator.pushNamed(
              context,
              CalculateScreen.route,
              arguments: CalculateScreenArguments(qSlope: null),
            );
          },
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _searchFocusNode.unfocus();
          },
          child: SafeArea(
            top: false,
            child:
                qSlopeListState is QSlopeListEmpty
                    ? Center(
                      child: IllustrationWidget(
                        assetPath: Assets.noData,
                        text:
                            AppLocalizations.of(
                              context,
                            ).homeScreenNoPreviousCalculationsFound,
                        onRefresh: null,
                      ),
                    )
                    : qSlopeListState is QSlopeListLoaded
                    ? Column(
                      children: [
                        HomeSearchAndFilterBar(
                          searchController: _searchController,
                          focusNode: _searchFocusNode,
                          onSearchChanged: (query) {
                            setState(() {
                              _searchQuery = query;
                            });
                          },
                          onSearchCleared: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                          selectedStatus: _selectedStatusFilter,
                          onStatusFilterChanged: (status) {
                            setState(() {
                              _selectedStatusFilter = status;
                            });
                          },
                          selectedSort: _selectedSortOption,
                          onSortChanged: (sort) {
                            setState(() {
                              _selectedSortOption = sort;
                            });
                          },
                        ),
                        Expanded(
                          child:
                              filteredList.isEmpty
                                  ? HomeEmptyFilterView(
                                    onClearFilters: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                        _selectedStatusFilter = null;
                                      });
                                    },
                                  )
                                  : ListView.builder(
                                    keyboardDismissBehavior:
                                        ScrollViewKeyboardDismissBehavior
                                            .onDrag,
                                    padding: EdgeInsets.only(
                                      left: getViewPortWidth(context) * 0.02,
                                      right: getViewPortWidth(context) * 0.02,
                                      top: getViewPortHeight(context) * 0.01,
                                      bottom: 80.0,
                                    ),
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      final item = filteredList[index];
                                      final isSelected = _selectedIds.contains(
                                        item.id,
                                      );

                                      return QSlopeListItemCard(
                                        item: item,
                                        isSelected: isSelected,
                                        isSelectionMode: isSelectionActive,
                                        onCheckboxChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              _selectedIds.add(item.id);
                                            } else {
                                              _selectedIds.remove(item.id);
                                            }
                                          });
                                        },
                                        onLongPress: () {
                                          setState(() {
                                            _isSelectionMode = true;
                                            if (isSelected) {
                                              _selectedIds.remove(item.id);
                                            } else {
                                              _selectedIds.add(item.id);
                                            }
                                          });
                                        },
                                        onTap: () {
                                          if (isSelectionActive) {
                                            setState(() {
                                              if (isSelected) {
                                                _selectedIds.remove(item.id);
                                              } else {
                                                _selectedIds.add(item.id);
                                              }
                                            });
                                          } else {
                                            Navigator.pushNamed(
                                              context,
                                              CalculateScreen.route,
                                              arguments:
                                                  CalculateScreenArguments(
                                                    qSlope: item.copyWith(),
                                                  ),
                                            );
                                          }
                                        },
                                      );
                                    },
                                  ),
                        ),
                      ],
                    )
                    : qSlopeListState is QSlopeListLoading
                    ? const Center(child: CustomProgressIndicator())
                    : Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          AppLocalizations.of(context).errorInLoadingQSlopeList,
                        ),
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
