//
//  ManifestClientSwift.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 4/11/16.
//  Copyright © 2016 Ooyala, Inc. All rights reserved.
//

import Foundation

@objc class ManifestClient : NSObject {
    let BaseURLString = "http://localhost:5000";
    
    func getManifest()
    {
        let manifestUrl = "http://player.ooyala.com/hls/playready/iphone/master/51cnc5eDotMHwAbScZXy2FSp_zXKinMh.m3u8"
        let urlString = "\(BaseURLString)/services/command/v1/manifests?url=\(manifestUrl)&includeUrls=true"
        if let operation = NetworkUtils.getOperation(urlString) {
            
            operation.setCompletionBlockWithSuccess(
                { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
                    if let array = responseObject   {
                        let manifestDigests = array as! NSArray;
                        if (manifestDigests.count > 0) {
                            let manifestDigest = manifestDigests.firstObject as! NSDictionary;
                            let urls = manifestDigest["urls"] as! NSDictionary;
                            let summary = manifestDigest["summary"];
                            if (urls.count > 0) {
                                //for (singleUrl in urls.allKeys) {
                                //      NSURL *url = [NSURL URLWithString:singleUrl];
                                //}
                            }
                        }
                    }
            },
                failure: { (operation, error) in
                    //println("Error: " + error.description)
            }
            )
            
            operation.start();
        }
    }
    
}
