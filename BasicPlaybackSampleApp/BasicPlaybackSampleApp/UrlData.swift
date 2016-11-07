//
//  UrlData.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 7/11/16.
//  Copyright © 2016 Ooyala, Inc. All rights reserved.
//

import Foundation

struct UrlData
{
    let type : String?

    let codec : String?
    
    let segment : Int?
    
    let segmentMs : Int?
    
    let startMs : Int?

    let bitrate : Int?
    
    let size : Int?
}

extension UrlData: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        type = try decoder.decode("type")
        codec = try decoder.decode("codec")
        segment = try decoder.decode("segment")
        segmentMs = try decoder.decode("segmentMs")
        startMs = try decoder.decode("startMs")
        bitrate = try decoder.decode("bitrate")
        size = try decoder.decode("size")
    }
}
