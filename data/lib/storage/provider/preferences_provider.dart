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

StateNotifierProvider<PreferenceNotifier<T?>, T?> createEncodedPrefProvider<T>({
  required String prefKey,
  T? defaultValue,
  required Map<String, dynamic> Function(T value) toJson,
  required T Function(Map<String, dynamic> json) fromJson,
}) {
  T? jsonPodToObject(String? json, T? defaultValue) {
    if (json == null) {
      return defaultValue;
    }
    return fromJson(jsonDecode(json));
  }

  return StateNotifierProvider<PreferenceNotifier<T?>, T?>(
    (ref) => PreferenceNotifier<T?>(
      jsonPodToObject(
        ref.watch(sharedPreferencesProvider).getString(prefKey),
        defaultValue,
      ),
      (curr) {
        final prefs = ref.watch(sharedPreferencesProvider);
        if (curr == null) {
          prefs.remove(prefKey);
        } else {
          prefs.setString(prefKey, jsonEncode(toJson(curr)));
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
