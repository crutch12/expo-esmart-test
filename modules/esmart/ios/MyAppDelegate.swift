import ExpoModulesCore
import libEsmartVirtualCard

public class MyAppDelegate: ExpoAppDelegateSubscriber {
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    libKeyCard.hostAppDidFinishLaunchingWithOptions(launchOptions)
    return true
  }
}