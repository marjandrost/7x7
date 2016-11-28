//
//  Reachability.swift
//  7x7
//
//  Created by Marjan Drost on 09-07-15.
//  Copyright (c) 2015 MD. All rights reserved.
//

import Foundation

open class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        
        var status:Bool = false
        let url = URL(string: "http://google.com/")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: URLResponse?
        
        _ = (try? NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)) as Data?
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                status = true
            }
        }
        
        return status
        
    }
}
