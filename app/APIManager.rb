class APIManager

  APIResources = 
    {
      get_stats: {
        path: '/stats',
        method: 'GET',
      }
    }

    EndpointURL = 'http://observer.shapehq.com/api/v1'
  

  def initialize
    @networkQueue = NSOperationQueue.new
    @networkQueue.addObserver(self, forKeyPath:'operations', options:0, context:nil)
  end

  @@sharedInstance = APIManager.new

  def self.sharedInstance
    @@sharedInstance
  end

  def fetchStats(completionLambda)
    fetchResource(:get_stats, lambda do |error, value|
      Dispatch::Queue.main.async do
        completionLambda.call(error, value)
      end
    end)
  end


  def fetchResource(resource_key, completionLambda)
    resource = APIResources[resource_key]
    request = NSMutableURLRequest.new
    request.URL = NSURL.URLWithString(EndpointURL + resource[:path])
    request.HTTPMethod = resource[:method]

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

  def observeValueForKeyPath(keyPath, ofObject:object, change:change, context:cotext)
    if keyPath == 'operations'
      evaluateActivityIndicator
    end

  end

  def evaluateActivityIndicator
    NSLog 'evaluation network indicator... count:%d' % @networkQueue.operations.count
    Dispatch::Queue.main.async do
      UIApplication.sharedApplication.networkActivityIndicatorVisible = (@networkQueue.operations.count > 0)
    end
  end
end