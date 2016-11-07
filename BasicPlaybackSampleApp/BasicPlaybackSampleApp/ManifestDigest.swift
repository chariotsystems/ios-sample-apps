//
//  ManifestDigest.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 7/11/16.
//  Copyright © 2016 Telstra. All rights reserved.
//  https://github.com/matthewcheok/JSONCodable
//

import Foundation

struct ManifestDigest
{
    let summary:Summary?
    
    let segments:[Segment]?
    
    let  urls:Dictionary<String, UrlData>

    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        summary = try decoder.decode("summary")
        segments = try decoder.decode("segments")
        urls = try decoder.decode("urls")
    }
}



