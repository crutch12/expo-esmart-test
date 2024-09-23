import ExpoModulesCore

// https://docs.expo.dev/modules/appdelegate-subscribers/
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

  // "required" is required
  public required init() {
    super.init()

    // @NOTE: Не создаём подписку на NotificationCenter.default.addObserver, т.к. методы класса AppDelegate и так реализуют эту подписку
    // к тому же в оригинале используется, зачем-то, обе реализации, что странно
    // https://www.hackingwithswift.com/example-code/system/how-to-detect-when-your-app-moves-to-the-background
  }

//   deinit {
//     NotificationCenter.default.removeObserver(self)
//   }

  public func applicationDidEnterBackground(_ application: UIApplication) {
    // The app is now in the background.
    libKeyCard.hostAppDidEnterBackground(application)
  }

  public func applicationDidBecomeActive(_ application: UIApplication) {
    // The app has become active.
    libKeyCard.hostAppDidBecomeActive(application)
  }

  public func applicationWillTerminate(_ application: UIApplication) {
    // The app is about to terminate.
    libKeyCard.hostAppDidWillTerminate(application)
  }
}