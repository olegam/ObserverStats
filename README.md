# ObserverStats
This iPhone app written in RubyMotion shows basic statistics from a webservice. Such as the total number of user of a service. 

The app connects to a webservice that works like this:
	
	GET test.com/api/v1/stats

	{
    "stats": [
        {
            "id": "new_users", 
            "name": "New Users Today", 
            "value": 7
        }, 
        ...
    ]
}

![Mandatory screenshot](http://github.com/olegam/ObserverStats/blob/master/marketing/screenshot1.png?raw=true)

The app was written in half a day and is my very first project with RubyMotion. This demonstrates that for an experienced iOS developer it is very easy to get started writing less code with RubyMotion.