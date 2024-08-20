import 'package:collection/collection.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QSlopeRepository {
  static final QSlopeRepository _instance = QSlopeRepository._internal();

  QSlopeRepository._internal();

  factory QSlopeRepository() {
    return _instance;
  }

  static const _qSlopeSharedPreferenceKey = "Q_SLOPES";

  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  Future<List<QSlope>> getAllQSlopes() {
    return _sharedPreferences
        .then((pref) => pref.getStringList(_qSlopeSharedPreferenceKey))
        .then((list) =>
            (list ?? []).map((value) => QSlope.fromJson(value)).toList());
  }

  Future<bool> saveQSlope(QSlope qSlope) async {
    var qSlopesList = await getAllQSlopes();
    int? qSlopeIndex;
    qSlopesList.firstWhereIndexedOrNull((index, element) {
      if (element.id == qSlope.id) {
        qSlopeIndex = index;
      }
      return element.id == qSlope.id;
    });
    if (qSlopeIndex != null) {
      qSlopesList[qSlopeIndex!] = qSlope;
    } else {
      qSlopesList.add(qSlope);
    }
    var qSlopeJsonList = qSlopesList.map((val) => val.toJson()).toList();
    return _sharedPreferences.then((pref) {
      return pref.setStringList(_qSlopeSharedPreferenceKey, qSlopeJsonList);
    });
  }

  Future<bool> deleteAllQSlopes() {
    return _sharedPreferences
        .then((pref) => pref.remove(_qSlopeSharedPreferenceKey));
  }

  Future<bool> deleteQSlope(String id) async {
    var qSlopesList = await getAllQSlopes();
    qSlopesList.removeWhere((qSlope) {
      return qSlope.id == id;
    });
    var jsonList = qSlopesList.map((qSlope) => qSlope.toJson()).toList();
    return _sharedPreferences.then(
        (pref) => pref.setStringList(_qSlopeSharedPreferenceKey, jsonList));
  }
}
