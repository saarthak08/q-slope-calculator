import 'package:isar/isar.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:q_slope_calculator/src/logic/service/isar_service.dart';

class QSlopeRepository {
  static final QSlopeRepository _instance = QSlopeRepository._internal();

  QSlopeRepository._internal();

  factory QSlopeRepository() {
    return _instance;
  }

  final IsarService _isarService = IsarService();

  Future<List<QSlope>> getAllQSlopes() {
    return _isarService.isar.qSlopes
        .where(sort: Sort.desc)
        .sortByCreatedAt()
        .findAll();
  }

  Future<QSlope?> getQSlope(int id) {
    return _isarService.isar.qSlopes.get(id);
  }

  Future<int> saveQSlope(QSlope qSlope) {
    return _isarService.isar.qSlopes.put(qSlope);
  }

  Future<void> deleteAllQSlopes() {
    return _isarService.isar.qSlopes.clear();
  }

  Future<void> deleteQSlope(int id) {
    return _isarService.isar.qSlopes.delete(id);
  }
}
