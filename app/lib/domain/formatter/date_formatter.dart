import '../extensions/context_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

enum DateFormatType {
  dayMonthYear("d MMMM, y"),
  dayMonthYearShort("d MMM, y"),
  monthYear("MMMM y"),
  monthYearShort("MMM y"),
  dayMonth("d MMMM"),
  dayMonthShort("d MMM"),
  year("y"),
  month("MMMM"),
  monthShort("MMM"),
  week("EEEE"),
  time("HH:mm:ss a"),
  timeShort("HH:mm a"),
  relative("relative");

  final String formatPattern;

  const DateFormatType(this.formatPattern);

  bool get isRelative => this == DateFormatType.relative;
}

extension DateFormatter on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  String format(BuildContext context, DateFormatType type) {
    if (isUtc) return toLocal().format(context, type);
    if (type.isRelative) return relativeFormat(context);
    return DateFormat(type.formatPattern).format(this);
  }

  String relativeFormat(BuildContext context) {
    if (isUtc) return toLocal().relativeFormat(context);
    final now = DateTime.now().toLocal();
    final diff = now.difference(this);
    if (diff.inDays == 0) {
      return context.l10n.common_today;
    } else if (diff.inDays == 1) {
      return context.l10n.common_yesterday;
    } else if (diff.inDays == -1) {
      return context.l10n.common_tomorrow;
    } else if (diff.inDays < 7) {
      return DateFormat(DateFormatType.week.formatPattern).format(this);
    } else if (now.year == year) {
      return DateFormat(DateFormatType.dayMonth.formatPattern).format(this);
    } else {
      return DateFormat(DateFormatType.dayMonthYear.formatPattern).format(this);
    }
  }
}
