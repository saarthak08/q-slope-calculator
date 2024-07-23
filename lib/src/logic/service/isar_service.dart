import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:q_slope_calculator/src/data/models/q_slope.dart';

/// [ISAR_SERVICE] Used for local storage
class IsarService {
  static final IsarService _instance = IsarService._internal();

  factory IsarService() => _instance;

  IsarService._internal();

  late Isar isar;

  Future<Isar> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [QSlopeSchema],
      inspector: true,
      directory: dir.path,
    );

    return isar;
  }
}
