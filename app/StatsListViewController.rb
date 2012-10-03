class StatsListViewController < UITableViewController
  # View controller showing a list ofcounters


  # For taking Default.png screenshots
  DefaultImageCaptureMode = false

  def viewDidLoad
    # don't call super for some reason
    view.dataSource = view.delegate = self
    self.wantsFullScreenLayout = true
    self.tableView.rowHeight = 116
    backgroundImage = UIImage.imageNamed('background')
    self.tableView.backgroundColor = UIColor.colorWithPatternImage(backgroundImage)
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)

    # refresh data when the app is brought to the forground
    NSNotificationCenter.defaultCenter.addObserverForName(UIApplicationWillEnterForegroundNotification, object:nil, queue:NSOperationQueue.new, usingBlock:lambda do |n|
        refreshData
    end)
  end

  def refreshData
    NSLog 'Refreshing data...'
    APIManager.sharedInstance.fetchStats(lambda do |error, stats|
      @stats = DefaultImageCaptureMode ? [] : stats[:stats]
      NSLog stats.description
      self.tableView.reloadData
    end)
  end

  def viewWillAppear(animated)
    super
    navigationController.setNavigationBarHidden(true, animated:false)
    refreshData
  end    

  def tableView(tableView, numberOfRowsInSection:section)
    @stats ? @stats.count : 0
  end

  CELLID = 'StatCellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # try to reuse a cell
    cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      # create a new cell
      cell = CounterTableViewCell.alloc.initWithStyle(UITableViewCellStyleValue1, reuseIdentifier:CELLID)  
      cell.selectionStyle = UITableViewCellSelectionStyleNone    
      cell
    end

    # configure the custom cell
    stat = @stats[indexPath.row]
    cell.name = stat[:name]
    cell.integerValue = stat[:value].intValue
    cell
  end

end
