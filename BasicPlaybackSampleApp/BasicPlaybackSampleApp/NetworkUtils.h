//
//  NetworkUtils.h
//  BasicPlaybackSampleApp
//
//  Created by alex on 1/11/2016.
//  Copyright (c) 2016, Telstra.
//  This is proprietary information of the Telstra Corporation Limited.
//  Copying or reproduction without prior written approval is prohibited.
//
#import "AFHTTPRequestOperation.h"

@interface NetworkUtils : NSObject
+ (AFHTTPRequestOperation *) getOperation:(NSString *)urlString;
@end


