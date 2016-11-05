//
//  NetworkUtilsSwift.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 4/11/16.
//  Copyright © Telstra. All rights reserved.
//

import Foundation
import NetworkExtension

@objc class NetworkUtils: NSObject {
    class func getOperation(_ urlString:String) -> AFHTTPRequestOperation? {
        
        let url = NSURL(string: urlString)
        let request = URLRequest(url: url! as URL)
        
        if let operation = AFHTTPRequestOperation(request: request) {
            operation.responseSerializer = AFJSONResponseSerializer()
            operation.credential = URLCredential(user:"mobile",password:"oooSecret",persistence: URLCredential.Persistence.none)
            return operation;
        }
        return nil;
    }

    
}
