import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

StateProvider<T> createPrefProvider<T>({
  required String prefKey,
  required T defaultValue,
}) {
  return StateProvider((ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final currentValue = prefs.get(prefKey) as T? ?? defaultValue;
    ref.listenSelf((previous, current) {
      if (current == null) {
        prefs.remove(prefKey);
      } else if (current is String) {
        prefs.setString(prefKey, current);
      } else if (current is bool) {
        prefs.setBool(prefKey, current);
      } else if (current is int) {
        prefs.setInt(prefKey, current);
      } else if (current is double) {
        prefs.setDouble(prefKey, current);
      } else if (current is List<String>) {
        prefs.setStringList(prefKey, current);
      }
    });
    return currentValue;
  });
}

StateProvider<T?> createEncodedPrefProvider<T>({
  required String prefKey,
  T? defaultValue,
  required Map<String, dynamic> Function(T value) toJson,
  required T Function(Map<String, dynamic> json) fromJson,
}) {
  return StateProvider((ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final currentValue = prefs.getString(prefKey);
    ref.listenSelf((previous, current) {
      if (current == null) {
        prefs.remove(prefKey);
      } else {
        prefs.setString(prefKey, jsonEncode(toJson(current)));
      }
    });
    return currentValue == null
        ? defaultValue
        : fromJson(jsonDecode(currentValue));
  });
}
