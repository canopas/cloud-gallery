import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final loggerProvider = Provider<Logger>(
  (ref) => Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 10,
      printEmojis: false,
      colors: false,
    ),
  ),
);

class UnitTestLoggerFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return false;
  }
}
