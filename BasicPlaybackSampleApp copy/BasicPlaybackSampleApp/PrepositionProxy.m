/**
 * User: alex eadie
 * Date: 1/11/2016
 * Copyright (c) 2016, Telstra.
 * This is proprietary information of the Telstra Corporation Limited.
 * Copying or reproduction without prior written approval is prohibited.
 *
 * With acknowledgement to 
 *     https://www.raywenderlich.com/59982/nsurlprotocol-tutorial
 *
 **/

#import "PrepositionProxy.h"
#import "AppDelegate.h"
#import "CachedURLResponse.h"

static NSString * const MyURLProtocolHandledKey = @"MyURLProtocolHandledKey";

@interface PrepositionProxy () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) CachedURLResponse *cachedResponse;
@end

@implementation PrepositionProxy
@synthesize cachedResponse;
//TODO: Top Priority: learn from peter jaber how to deploy to my device.
//TODO: is this useful?
//https://github.com/twitter/CocoaSPDY/blob/master/SPDY/SPDYProtocol.m
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    NSString *scheme = request.URL.scheme.lowercaseString;
    if (![scheme isEqualToString:@"http"] && ![scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:MyURLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void) startLoading {
    self.cachedResponse = [self cachedResponseForCurrentRequest];
    if (self.cachedResponse  ) {
        
//  This recreation of the response from core data does not work - the app crashes sometimes.
//  So this cannot be recreating the same object that the client expects.
//  My guess this is because its actually an NSHTTPURLResponse that we need with full bells and whistles.
//       self.response = [[NSURLResponse alloc] initWithURL:[[NSURL alloc] initWithString:self.response.URL.absoluteString]
//                                                      MIMEType:self.cachedResponse.mimeType
//                                         expectedContentLength:self.cachedResponse.data.length
//                                              textEncodingName:self.cachedResponse.encoding];
//        
            [self.client URLProtocol:self didReceiveResponse:self.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [self.client URLProtocol:self didLoadData:self.cachedResponse.data];
            [self.client URLProtocolDidFinishLoading:self];
        
    } else {
        NSMutableURLRequest *newRequest = [self.request mutableCopy];
        [NSURLProtocol setProperty:@YES forKey:MyURLProtocolHandledKey inRequest:newRequest];
        
        self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
        
    }
    
}


- (void) stopLoading {
    
    [self.connection cancel];
    self.mutableData = nil;
    
}

#pragma mark - NSURLConnectionDelegate

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    self.response = response;
    self.mutableData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.client URLProtocol:self didLoadData:data];
    [self.mutableData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
    
    [self saveCachedResponse];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - Private

- (CachedURLResponse *) cachedResponseForCurrentRequest {
    
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if(delegate.lastPurgeDate == nil ||
        [[self yesterday] compare: delegate.lastPurgeDate] == NSOrderedDescending)
        // if start is later in time than end
    {
        [self deleteOutOfDate];
    }
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CachedURLResponse"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", self.request.URL.absoluteString];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    self.response = [delegate.urlCache objectForKey:self.request.URL.absoluteString];
    if (result && result.count > 0 && self.response) {
        CachedURLResponse * cachedURLResponse = result[0];
        return cachedURLResponse;
    }
    
    return nil;
    
}

- (void) deleteAll {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"CachedURLResponse" inManagedObjectContext:context]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *cars = [context executeFetchRequest:allCars error:&error];
    //error handling goes here
    for (NSManagedObject *car in cars) {
        [context deleteObject:car];
    }
    
    NSError *saveError = nil;
    [context save:&saveError];
}

- (void) deleteOutOfDate {
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CachedURLResponse"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp < %@", [self yesterday]];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:20];
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if ([result count] == 0){
        delegate.lastPurgeDate = [NSDate date];
    }
    for (NSManagedObject *car in result) {
        [context deleteObject:car];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}

- (NSDate*) yesterday {
    NSDate* date = [NSDate date];
    
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    //comps.day = -1;
    comps.minute = -2;//TODO: what should this be? 6 hours?
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDate* yesterday = [calendar dateByAddingComponents:comps toDate:date options:0];
    return yesterday;
}


- (void) saveCachedResponse {
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    self.cachedResponse = [NSEntityDescription insertNewObjectForEntityForName:@"CachedURLResponse"
                                                                     inManagedObjectContext:context];

    self.cachedResponse.data = self.mutableData;
    self.cachedResponse.url = self.request.URL.absoluteString;
    self.cachedResponse.timestamp = [NSDate date];
    self.cachedResponse.mimeType = self.response.MIMEType;
    self.cachedResponse.encoding = self.response.textEncodingName;
    
    NSError *error;
    [context save:&error];
    if (error) {
        NSLog(@"Could not cache the response.");
    }
    [delegate.urlCache setObject:self.response forKey:self.request.URL.absoluteString];
    
}

@end
