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

end