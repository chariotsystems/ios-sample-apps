//
//  ManifestClient.m
//  BasicPlaybackSampleApp
//
//  Created by alex on 1/11/2016.
//  Copyright (c) 2016, Telstra.
//  This is proprietary information of the Telstra Corporation Limited.
//  Copying or reproduction without prior written approval is prohibited.
//


#import <Foundation/Foundation.h>
#import "ManifestClient.h"
#import "NSDictionary+manifestDigest.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "NSData+Base64.h"
#import "NetworkUtils.h"


static NSString * const BaseURLString = @"http://localhost:5000";


@interface ManifestClient ()
@property(strong) NSDictionary *manifestDigest;
@property(strong) NSArray *manifestDigests;

@end

@implementation ManifestClient

- (void) getManifest
{
    NSString* manifestUrl = @"http://player.ooyala.com/hls/playready/iphone/master/51cnc5eDotMHwAbScZXy2FSp_zXKinMh.m3u8";
    NSString *urlString = [NSString stringWithFormat:@"%@/services/command/v1/manifests?url=%@&includeUrls=true", BaseURLString, manifestUrl];
    
    AFHTTPRequestOperation *operation = [NetworkUtils getOperation:urlString];
   
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.manifestDigests = (NSArray *)responseObject;
        if ([self.manifestDigests count] > 0) {
            self.manifestDigest = [self.manifestDigests firstObject];
            NSDictionary* urls = [self.manifestDigest urls];
            NSDictionary* summary = [self.manifestDigest summary];
            if ([urls count] > 0) {
                for (NSString* singleUrl in urls.allKeys) {
              //      NSURL *url = [NSURL URLWithString:singleUrl];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.manifestDigests = [[NSArray alloc] init];    //Error handling goes here.
    }];
    
 
    [operation start];
}


@end
