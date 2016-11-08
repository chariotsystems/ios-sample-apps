//
//  Segment.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 7/11/16.
//  Copyright © 2016 Ooyala, Inc. All rights reserved.
//

import Foundation

struct Segment{
    
  let segmentMs : Int?
 
  let startMs : Int?
  
  let sources : [Source]?

}

extension Segment: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        segmentMs = try decoder.decode("segmentMs")
        startMs = try decoder.decode("startMs")
        sources = try decoder.decode("sources")
    }
}
