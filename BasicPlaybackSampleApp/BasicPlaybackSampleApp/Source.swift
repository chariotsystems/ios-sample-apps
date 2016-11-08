//
//  Source.swift
//  BasicPlaybackSampleApp
//
//
//  Created by admin on 7/11/16.
//  Copyright © 2016 Telstra, Inc. All rights reserved.
//

import Foundation

struct Source{
    
    let type : String?
    
    let url : String?
    
    let codecs : String?
    
    let  bitrate : Int?;
    
    let size : Int?;
}

extension Source: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        type = try decoder.decode("type")
        url = try decoder.decode("url")
        codecs = try decoder.decode("codecs")
        bitrate = try decoder.decode("bitrate")
        size = try decoder.decode("size")
    }
}
