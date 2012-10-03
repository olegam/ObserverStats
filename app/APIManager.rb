class APIManager
  # Singleton class to interface with the API and update the network activity indicator

  # describe available API resources in a structured way
  APIResources = 
    {
      get_stats: {
        path: '/stats',
        method: 'GET',
      }
    }

  # the resource's path is appended to this enpoint URL
  EndpointURL = 'http://observer.shapehq.com/api/v1'
  
  def initialize
    @networkQueue = NSOperationQueue.new
    # observe for changes on the queue to update the network activity indicator
    @networkQueue.addObserver(self, forKeyPath:'operations', options:0, context:nil)
  end

  # Ruby way to create a singleton
  @@sharedInstance = APIManager.new

  def self.sharedInstance
    @@sharedInstance
  end

  # public method to start fetching stats
  def fetchStats(completionLambda)
    fetchResource(:get_stats, lambda do |error, value|
      Dispatch::Queue.main.async do
        completionLambda.call(error, value)
      end
    end)
  end


  # generic method to fetch a resource, handle errors and parse JSON
  def fetchResource(resource_key, completionLambda)
    resource = APIResources[resource_key]
    request = NSMutableURLRequest.new
    request.URL = NSURL.URLWithString(EndpointURL + resource[:path])
    request.HTTPMethod = resource[:method]

    # make sure to show the network activity inddicator right away
    UIApplication.sharedApplication.networkActivityIndicatorVisible = true
    NSURLConnection.sendAsynchronousRequest(request, queue:@networkQueue, completionHandler: lambda do |response, data, error|
      if error then completionLambda.call(error, nil) end
      if response.statusCode >= 400
        error = NSError.errorWithDomain('com.shapehq.observer.stats', code:response.statusCode, userInfo:{NSLocalizedDescriptionKey: "Request error #{response.statusCode}"})
        completionLambda.call(error, nil)
      end
      jsonObject = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingAllowFragments, error:nil)
      completionLambda.call(error, jsonObject)
    end)
  end

  # handle KVO notifications
  def observeValueForKeyPath(keyPath, ofObject:object, change:change, context:cotext)
    if keyPath == 'operations'
      evaluateActivityIndicator
    end

  end

  # evaluate if the network indicator should still be shown
  def evaluateActivityIndicator
    # make sure UI updates happens on the main thread
    Dispatch::Queue.main.async do
      UIApplication.sharedApplication.networkActivityIndicatorVisible = (@networkQueue.operations.count > 0)
    end
  end
end