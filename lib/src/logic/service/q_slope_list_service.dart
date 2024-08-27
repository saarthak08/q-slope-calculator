import 'package:q_slope_calculator/src/data/common/qslope_error.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/repository/q_slope_repository.dart';
import 'package:q_slope_calculator/src/utils/logger.dart';
import 'package:q_slope_calculator/src/data/common/result.dart';

class QSlopeListService {
  static final QSlopeListService _instance = QSlopeListService._internal();

  QSlopeListService._internal();

  factory QSlopeListService() {
    return _instance;
  }

  final QSlopeRepository _qSlopeCalculationsRepository = QSlopeRepository();

  Future<Result<List<QSlope>>> getQSlopesList() async {
    try {
      return Success(await _qSlopeCalculationsRepository.getAllQSlopes());
    } catch (err, s) {
      getLogger()
          .e('Error in getting Q-slopes list', error: err, stackTrace: s);
      return Failure(QSlopeError(type: QSlopeErrorType.listLoadError));
    }
  }

  Future<Result<bool?>> saveQSlopeToList(QSlope qslope) async {
    try {
      return Success(await _qSlopeCalculationsRepository.saveQSlope(qslope));
    } catch (err, s) {
      getLogger()
          .e('Error in saving Q-slope: $qslope', error: err, stackTrace: s);
      return Failure(QSlopeError(type: QSlopeErrorType.saveError));
    }
  }

  Future<Result<bool>> clearQSlopeList() async {
    try {
      return Success(await _qSlopeCalculationsRepository.deleteAllQSlopes());
    } catch (err, s) {
      getLogger()
          .e('Error in clearing Q-slope list', error: err, stackTrace: s);
      return Failure(QSlopeError(type: QSlopeErrorType.clearListError));
    }
  }

  Future<Result<bool>> deleteQSlope(String id) async {
    try {
      return Success(await _qSlopeCalculationsRepository.deleteQSlope(id));
    } catch (err, s) {
      getLogger().e('Error in deleting Q-slope', error: err, stackTrace: s);
      return Failure(QSlopeError(type: QSlopeErrorType.deleteError));
    }
  }

  Future<Result<bool>> deleteMultipleQSlopes(List<String> ids) async {
    try {
      return Success(
          await _qSlopeCalculationsRepository.deleteMultipleQSlopes(ids));
    } catch (err, s) {
      getLogger()
          .e('Error in deleting multiple Q-slopes', error: err, stackTrace: s);
      return Failure(QSlopeError(type: QSlopeErrorType.deleteError));
    }
  }
}
