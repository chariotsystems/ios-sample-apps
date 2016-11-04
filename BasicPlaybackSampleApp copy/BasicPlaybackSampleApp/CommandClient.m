/**
 * User: alex eadie
 * Date: 1/11/2016
 * Copyright (c) 2016, Telstra.
 * This is proprietary information of the Telstra Corporation Limited.
 * Copying or reproduction without prior written approval is prohibited.
 **/

#import <Foundation/Foundation.h>
#import "CommandClient.h"
//#import "NSDictionary+command.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "NSData+Base64.h"
#import "NetworkUtils.h"


static NSString * const BaseURLString = @"http://localhost:5000";


@interface CommandClient ()

@property(strong) NSDictionary *commandResponse;

@end

@implementation CommandClient

- (void) getCommands
{
    NSString* userId = @"userId";
    NSString* appId = @"appId";
    NSString* urlString = [NSString stringWithFormat:@"%@/services/command/v1/apps/%@/users/%@/commands", BaseURLString, appId, userId];
    
    AFHTTPRequestOperation *operation = [NetworkUtils getOperation:urlString];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
        self.commandResponse = (NSDictionary *)responseObject;

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.commandResponse =  nil;    //Error handling goes here.
    }];
    
 
    [operation start];
}


@end
