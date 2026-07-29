import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/src/data/common/qslope_error.dart';
import 'package:q_slope_calculator/src/data/common/result.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/service/q_slope_list_service.dart';

part 'q_slope_list_state.dart';

/// Manages the state of the Q-Slope list throughout the application.
/// It interacts with the [QSlopeListService] to load, save, and delete records,
/// and emits states ([QSlopeListLoading], [QSlopeListLoaded], [QSlopeListEmpty])
/// to update the UI reactively.
class QSlopeListCubit extends Cubit<QSlopeListState> {
  final QSlopeListService _qSlopeListService = QSlopeListService();
  QSlopeListCubit() : super(QSlopeListLoading());

  Future<void> loadQSlopeList() async {
    emit(QSlopeListLoading());
    Result<List<QSlope>> qSlopeListResult =
        await _qSlopeListService.getQSlopesList();
    qSlopeListResult.when(
      onSuccess: (data) {
        if (data.isEmpty) {
          emit(QSlopeListEmpty());
        } else {
          emit(QSlopeListLoaded(data));
        }
      },
      onError: (error) {
        if (error is QSlopeError) {
          emit(QSlopeListLoadingErrorState(error));
        }
      },
    );
  }

  Future<Result> saveQSlopeToList(QSlope qSlope) async {
    var result = await _qSlopeListService.saveQSlopeToList(qSlope);
    result.when(
      onError: (error) {
        if (error is QSlopeError) {
          emit(QSlopeListOperationErrorState(error));
        }
      },
    );
    await loadQSlopeList();
    return result;
  }

  Future<Result> clearQSlopeList() async {
    var result = await _qSlopeListService.clearQSlopeList();
    result.when(
      onError: (error) {
        if (error is QSlopeError) {
          emit(QSlopeListOperationErrorState(error));
        }
      },
    );
    await loadQSlopeList();
    return result;
  }

  Future<Result> deleteQSlopeFromList(String id) async {
    var result = await _qSlopeListService.deleteQSlope(id);
    result.when(
      onError: (error) {
        if (error is QSlopeError) {
          emit(QSlopeListOperationErrorState(error));
        }
      },
    );
    await loadQSlopeList();
    return result;
  }

  Future<Result> deleteMultipleQSlopesFromList(List<String> ids) async {
    var result = await _qSlopeListService.deleteMultipleQSlopes(ids);
    result.when(
      onError: (error) {
        if (error is QSlopeError) {
          emit(QSlopeListOperationErrorState(error));
        }
      },
    );
    await loadQSlopeList();
    return result;
  }
}
