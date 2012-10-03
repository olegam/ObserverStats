# ObserverStats
iPhone app written in RubyMotion to show simple numeric statistics from a REST webservice. Could be the total number of users of an app or service. 

Connects to a webservice that works like this:
	
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


The code was written in half a day and is my first project with RubyMotion. This demonstrates that for an experienced iOS developer it is very easy to get started writing apps with less code using RubyMotion.

![Mandatory screenshot](http://github.com/olegam/ObserverStats/blob/master/marketing/screenshot1.png?raw=true)
