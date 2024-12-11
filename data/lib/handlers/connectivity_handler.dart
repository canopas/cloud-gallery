import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../apis/network/urls.dart';

final connectivityHandlerProvider = Provider<ConnectivityHandler>((ref) {
  return ConnectivityHandler();
});

class ConnectivityHandler {
  Future<void> lookUpDropbox() async {
    await InternetAddress.lookup(BaseURL.dropboxV2);
  }

  Future<void> lookUpGoogleDrive() async {
    await InternetAddress.lookup(BaseURL.googleDriveV3);
  }

  Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // Internet access
      }
    } on SocketException catch (_) {
      return false; // No Internet access
    }
    return false;
  }
}
