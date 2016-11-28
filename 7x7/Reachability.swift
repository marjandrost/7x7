//
//  Reachability.swift
//  7x7
//
//  Created by Marjan Drost on 09-07-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import Foundation

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        
        var status:Bool = false
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        
        _ = (try? NSURLConnection.sendSynchronousRequest(request, returningResponse: &response)) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        
        return status
        
    }
}
