import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/data/repository/q_slope_repository.dart';
import 'package:q_slope_calculator/src/utils/logger.dart';

class QSlopeListService {
  static final QSlopeListService _instance = QSlopeListService._internal();

  QSlopeListService._internal();

  factory QSlopeListService() {
    return _instance;
  }

  final QSlopeRepository _qSlopeCalculationsRepository = QSlopeRepository();

  Future<List<QSlope>> getQSlopesList() async {
    try {
      return await _qSlopeCalculationsRepository.getAllQSlopes();
    } catch (err, s) {
      getLogger()
          .e('Error in getting Q-slopes list', error: err, stackTrace: s);
      rethrow;
    }
  }

  Future<int?> saveQSlopeToList(QSlope qslope) async {
    try {
      return await _qSlopeCalculationsRepository.saveQSlope(qslope);
    } catch (err, s) {
      getLogger()
          .e('Error in saving Q-slope: $qslope', error: err, stackTrace: s);
      rethrow;
    }
  }

  Future<void> clearQSlopeList() async {
    try {
      return await _qSlopeCalculationsRepository.deleteAllQSlopes();
    } catch (err, s) {
      getLogger()
          .e('Error in clearing Q-slope list', error: err, stackTrace: s);
      rethrow;
    }
  }
}
