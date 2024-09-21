import ExpoModulesCore

public class MyAppDelegate: ExpoAppDelegateSubscriber {
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // 3.3.7
    UserDefaults.standard.set(true, forKey: "VirtualCardEnabled")
    UserDefaults.standard.set(true, forKey: "LogsEnabled")
    UserDefaults.standard.set(MODE_HANDS_FREE, forKey: "CardMode")

    Logger.purgeLogs()
    Logger.realTimeLog(true)

    if Logger.logsPaused() {
        Logger.pauseLogs()  // метод вкл/выкл логов один и тот же
    }

    libKeyCard.hostAppDidFinishLaunching(launchOptions)

    BLEAdvertiser.backgroundProcessingEnabled(true)
    BLEAdvertiser.enableSendUserId()

    return true
  }
}