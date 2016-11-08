//
//  Summary.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 7/11/16.
//  Copyright © 2016 Telstra. All rights reserved.
//

import Foundation

struct Summary {
    let manifestUrl: String?
    
    let bitrates: [Int]?
    
    let totalMs: Int?
    
    let totalSegments: Int?
}

extension Summary: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        manifestUrl = try decoder.decode("manifestUrl")
        bitrates = try decoder.decode("bitrates")
        totalMs = try decoder.decode("totalMs")
        totalSegments = try decoder.decode("totalSegments")
    }
}
