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
    final packageName =
        await PackageInfo.fromPlatform().then((value) => value.packageName);
    final targetUrl = (Platform.isAndroid)
        ? "market://details?id=$packageName"
        : (Platform.isIOS)
            ? "itms-apps://itunes.apple.com/app/$packageName"
            : "";

    await launchUrlString(targetUrl);
  }
}
