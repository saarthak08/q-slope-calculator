part of 'q_slope_list_cubit.dart';

@immutable
abstract class QSlopeListState {}

class QSlopeListEmpty extends QSlopeListState {}

class QSlopeListLoading extends QSlopeListState {}

class QSlopeListLoaded extends QSlopeListState {
  final List<QSlope> qSlopeList;

  QSlopeListLoaded(this.qSlopeList);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QSlopeListLoaded &&
        listEquals(other.qSlopeList, qSlopeList);
  }

  @override
  int get hashCode => qSlopeList.hashCode;

  QSlopeListLoaded copyWith({required List<QSlope> qSlopeList}) {
    return QSlopeListLoaded(qSlopeList);
  }
}

class QSlopeListLoadingErrorState extends QSlopeListState {
  final QSlopeError qSlopeError;
  QSlopeListLoadingErrorState(this.qSlopeError);
}

class QSlopeListOperationErrorState extends QSlopeListState {
  final QSlopeError qSlopeError;
  QSlopeListOperationErrorState(this.qSlopeError);
}
