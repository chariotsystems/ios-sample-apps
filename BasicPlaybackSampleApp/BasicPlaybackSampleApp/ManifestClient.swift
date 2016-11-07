//
//  ManifestClientSwift.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 4/11/16.
//  Copyright © 2016 Telstra. All rights reserved.
//

import Foundation

@objc class ManifestClient : NSObject {
    let BaseURLString = "http://localhost:5000";
    
    func getManifest(manifestUrl:String, includeUrls:Bool, includeSegments:Bool,
                     successResponse:@escaping ([ManifestDigest])->Void, failureResponse:@escaping (String)->Void)
    {
         let urlString = "\(BaseURLString)/services/command/v1/manifests?url=\(manifestUrl)&includeUrls=true"
        if let operation = NetworkUtils.getOperation(urlString) {
            
            operation.setCompletionBlockWithSuccess(
                { (operation: AFHTTPRequestOperation?, responseObject: Any?) in
                    if let error = responseObject as? NSDictionary {
                        if (error.count > 0) {
                           //TODO: unmarshall me to get error reason
                        }// can get status 401 here if password is invalid.
                        failureResponse("errorPayload")
                    } else if let manifestDigestsJson = responseObject as? NSArray {
                        do{
                            var manifestDigests = [ManifestDigest]()
                            for individual in manifestDigestsJson {
                                let manifestDigest = try ManifestDigest(object: individual as! JSONObject)
                                    manifestDigests.append( manifestDigest)
                            }
                            successResponse(manifestDigests)
                        } catch {
                                 //TODO:
                        }                        
                    }
                },
                failure: { (operation, error) in
                    if let errorDescription = error?.localizedDescription {
                        failureResponse(errorDescription)
                    } else {
                        failureResponse("unknown error");
                    }
                }
            )
            
            operation.start();
        }
    }
    
    // TODO: move me to ManifestService
    func getManifestHarness(){
        let manifestUrl = "http://player.ooyala.com/hls/playready/iphone/master/51cnc5eDotMHwAbScZXy2FSp_zXKinMh.m3u8"

        getManifest(manifestUrl: manifestUrl, includeUrls: true, includeSegments: true, successResponse: {manifestDigest in
            
            },
            failureResponse: {error in
        })
    }
    
}
