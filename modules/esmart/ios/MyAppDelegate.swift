import ExpoModulesCore

public class MyAppDelegate: ExpoAppDelegateSubscriber {
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    libKeyCard.hostAppDidFinishLaunching(launchOptions)
    return true
  }
}