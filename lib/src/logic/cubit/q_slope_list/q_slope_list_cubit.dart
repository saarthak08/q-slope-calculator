import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/service/q_slope_list_service.dart';

part 'q_slope_list_state.dart';

class QSlopeListCubit extends Cubit<QSlopeListState> {
  final QSlopeListService _qSlopeListService = QSlopeListService();
  QSlopeListCubit() : super(QSlopeListLoading());

  Future<void> loadQSlopeList() async {
    emit(QSlopeListLoading());
    try {
      List<QSlope>? qSlopeList = await _qSlopeListService.getQSlopesList();
      if (qSlopeList.isNotEmpty) {
        emit(QSlopeListLoaded(qSlopeList));
      } else {
        emit(QSlopeListEmpty());
      }
    } on Exception catch (ex) {
      emit(QSlopeListLoadingErrorState(ex));
    }
  }

  Future<void> saveQSlopeToList(QSlope qSlope) async {
    try {
      await _qSlopeListService.saveQSlopeToList(qSlope);
    } on Exception catch (ex) {
      emit(QSlopeSaveToListErrorState(ex));
    }
    await loadQSlopeList();
  }

  Future<void> clearQSlopeList() async {
    try {
      await _qSlopeListService.clearQSlopeList();
    } on Exception catch (ex) {
      emit(QSlopeClearListErrorState(ex));
    }
    await loadQSlopeList();
  }

  Future<void> deleteQSlopeFromList(int id) async {
    try {
      await _qSlopeListService.deleteQSlope(id);
    } on Exception catch (ex) {
      emit(QSlopeDeleteFromListErrorState(ex));
    }
    await loadQSlopeList();
  }
}
