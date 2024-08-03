import 'package:logger/logger.dart';

Logger? _logger;

void closeLogger() {
  if (_logger != null) {
    _logger!.close();
  }
}

Logger getLogger() {
  _logger ??= Logger(printer: PrettyPrinter());
  return _logger!;
}
