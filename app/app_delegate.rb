class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleBlackTranslucent
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    statsListViewController = StatsListViewController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(statsListViewController)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end
end
