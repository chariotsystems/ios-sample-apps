//
//  NetworkUtilsSwift.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 4/11/16.
//  Copyright © Telstra. All rights reserved.
//

import Foundation
import NetworkExtension

@objc class NetworkUtilsSwift: NSObject {
    class func getOperation(_ urlString:String) -> AFHTTPRequestOperation? {
        let url = NSURL(string: urlString)
        var request = URLRequest(url: url! as URL)
        let passwordString = "mobile:oooSecret"
        let passwordData = passwordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = passwordData!.base64EncodedString(options: NSData.Base64EncodingOptions())
        let auth = "Basic \(base64EncodedCredential)"
        request.setValue(_:auth, forHTTPHeaderField:"Authorization")
        if let operation = AFHTTPRequestOperation(request: request) {
            // Comment out the next line if json deserialize is not required
            operation.responseSerializer = AFJSONResponseSerializer()
            return operation;
        }
        return nil;
    }

    
}