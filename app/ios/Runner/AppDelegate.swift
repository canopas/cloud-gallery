import UIKit
import Flutter
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
     // WorkmanagerPlugin.registerTask(withIdentifier: "cloud-gallery-background-process")
    WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "cloud-gallery-background-process")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
