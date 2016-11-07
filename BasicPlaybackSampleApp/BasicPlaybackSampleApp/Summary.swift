//
//  Summary.swift
//  BasicPlaybackSampleApp
//
//  Created by admin on 7/11/16.
//  Copyright © 2016 Ooyala, Inc. All rights reserved.
//

import Foundation

struct Summary {
    
}

extension Summary: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
//        name = try decoder.decode("name")
//        address = try decoder.decode("address")
    }
}
