/**
 * User: alex eadie
 * Date: 1/11/2016
 * Copyright (c) 2016, Telstra.
 * This is proprietary information of the Telstra Corporation Limited.
 * Copying or reproduction without prior written approval is prohibited.
 **/

#import <Foundation/Foundation.h>
#import "CommandClient.h"
#import "NSDictionary+weather.h"
#import "NSDictionary+weather_package.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"


static NSString * const BaseURLString = @"http://www.raywenderlich.com/demos/weather_sample/";


// https://www.raywenderlich.com/59255/afnetworking-2-0-tutorial
@interface CommandClient ()
@property(nonatomic, strong) NSMutableDictionary *currentDictionary;   // current section being parsed
@property(nonatomic, strong) NSMutableDictionary *xmlWeather;          // completed parsed xml response
@property(nonatomic, strong) NSString *elementName;
@property(nonatomic, strong) NSMutableString *outstring;
@property(strong) NSDictionary *weather;

@end

@implementation CommandClient

- (void) getCommands
{
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
        self.weather = (NSDictionary *)responseObject;

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //Error handling goes here.
    }];
    
 
    [operation start];
}

- (void) loadBinaryData
{
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Error handling goes here.
    }];
    
    
    [operation start];
}
@end
