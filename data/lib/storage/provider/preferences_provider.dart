import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

StateNotifierProvider<PreferenceNotifier<T>, T> createPrefProvider<T>({
  required String prefKey,
  required T defaultValue,
}) {
  return StateNotifierProvider<PreferenceNotifier<T>, T>(
    (ref) => PreferenceNotifier<T>(
      ref.watch(sharedPreferencesProvider).get(prefKey) as T? ?? defaultValue,
      (curr) {
        final prefs = ref.watch(sharedPreferencesProvider);
        if (curr == null) {
          prefs.remove(prefKey);
        } else if (curr is String) {
          prefs.setString(prefKey, curr);
        } else if (curr is bool) {
          prefs.setBool(prefKey, curr);
        } else if (curr is int) {
          prefs.setInt(prefKey, curr);
        } else if (curr is double) {
          prefs.setDouble(prefKey, curr);
        } else if (curr is List<String>) {
          prefs.setStringList(prefKey, curr);
        }
      },
    ),
  );
}

class PreferenceNotifier<T> extends StateNotifier<T> {
  Function(T curr)? onUpdate;

  PreferenceNotifier(
    super.value,
    this.onUpdate,
  );

  @override
  set state(T value) {
    super.state = value;
    onUpdate?.call(value);
  }

  @override
  T get state => super.state;
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
