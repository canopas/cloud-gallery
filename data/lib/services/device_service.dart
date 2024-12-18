import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

final deviceServiceProvider = Provider(
  (ref) => DeviceService(),
);

class DeviceService {
  Future<String> get version async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> rateApp() async {
    final targetUrl = (Platform.isIOS || Platform.isMacOS)
        ? "itms-apps://itunes.apple.com/app/6480052005"
        : "market://details?id=com.canopas.cloud_gallery";
    await launchUrlString(targetUrl);
  }
}
