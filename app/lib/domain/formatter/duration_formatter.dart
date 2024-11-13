extension DurationFormatter on Duration {
  String get format {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final String twoDigitHours = twoDigits(inHours.remainder(24));
    final String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(inSeconds.remainder(60));

    if (inHours > 0) {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
