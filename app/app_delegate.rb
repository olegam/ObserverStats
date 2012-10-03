class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleBlackTranslucent
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # Instantiate a StatsListViewControler and embed it in a NavigationController
    statsListViewController = StatsListViewController.alloc.init
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(statsListViewController)
    @window.rootViewController.wantsFullScreenLayout = true # to make the view go behind the status bar
    @window.makeKeyAndVisible

    true
  end
end
