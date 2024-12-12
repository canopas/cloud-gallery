import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../errors/app_error.dart';

final connectivityHandlerProvider = Provider<ConnectivityHandler>((ref) {
  return ConnectivityHandler();
});

class ConnectivityHandler {
  // This method is used to check internet connection
  Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet access
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  // This method is used to check internet connection and throw an exception if there is no internet connection
  Future<void> checkInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return; // Internet access
      }
    } on SocketException catch (_) {
      throw NoConnectionError();
    }
    throw NoConnectionError();
  }
}
