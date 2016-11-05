//
//  NetworkUtils.m
//  BasicPlaybackSampleApp
//
//  Created by alex on 1/11/2016.
//  Copyright (c) 2016, Telstra.
//  This is proprietary information of the Telstra Corporation Limited.
//  Copying or reproduction without prior written approval is prohibited.
//

#import <Foundation/Foundation.h>
#import "NetworkUtils.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
//#import "NSData+Base64.h"

static NSString * const BaseURLString = @"http://localhost:5000";


@interface NetworkUtils ()

@end

@implementation NetworkUtils

+ (AFHTTPRequestOperation *) getOperation:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLCredential *credential = [NSURLCredential credentialWithUser:@"mobile" password:@"oooSecret" persistence:NSURLCredentialPersistenceNone];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"mobile", @"oooSecret"];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = @"Basic bW9iaWxlOm9vb1NlY3JldA==";//[NSString stringWithFormat:@"Basic %@", [authData base64EncodedString]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    // Comment out the next line if json deserialize is not required
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
  //  [operation setCredential:credential];
    return operation;
}
@end
