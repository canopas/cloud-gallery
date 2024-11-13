import 'dart:math';

extension BytesFormatter on int {
  String get formatBytes {
    const List<String> suffixes = [
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB',
    ];
    if (this == 0) return '0 ${suffixes[0]}';
    final i = (this == 0) ? 0 : (log(this) / log(1024)).floor();
    final formattedValue = (this / pow(1024, i)).toStringAsFixed(2);
    return '${formattedValue.endsWith('.00') ? formattedValue.substring(0, formattedValue.length - 3) : formattedValue} ${suffixes[i]}';
  }
}
