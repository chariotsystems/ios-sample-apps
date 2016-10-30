//
//  MyURLProtocol.m
//  NSURLProtocolExample
//
//  Created by Rocir Marcos Leite Santiago on 11/29/13.
//  Copyright (c) 2013 Rocir Santiago. All rights reserved.
//

#import "MyURLProtocol.h"

// AppDelegate
#import "AppDelegate.h"

// Model
#import "CachedURLResponse.h"

static NSString * const MyURLProtocolHandledKey = @"MyURLProtocolHandledKey";

@interface MyURLProtocol () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSURLResponse *response;
@property (strong) CachedURLResponse *cachedResponse;
@end

@implementation MyURLProtocol
@synthesize cachedResponse;

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    
    if ([NSURLProtocol propertyForKey:MyURLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void) startLoading {
    //[self deleteAll];
    self.cachedResponse = [self cachedResponseForCurrentRequest];
    if (self.cachedResponse  /*&& cachedResponse.data.length < 900*/ ) {
        
        NSData *data = self.cachedResponse.data;
        
        self.response = self.cachedResponse.response;
        //[[NSURLResponse alloc] initWithURL:self.cachedResponse.url.URL
//                                                      MIMEType:self.cachedResponse.mimeType
//                                         expectedContentLength:data.length
//                                              textEncodingName:self.cachedResponse.mimeType];
            
            [self.client URLProtocol:self didReceiveResponse:self.response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
            [self.client URLProtocol:self didLoadData:data];
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
//    NSManagedObjectContext *context = delegate.managedObjectContext;
//    
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CachedURLResponse"
//                                              inManagedObjectContext:context];
//    [fetchRequest setEntity:entity];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"url == %@", self.request.URL.absoluteString];
//    [fetchRequest setPredicate:predicate];
//    [fetchRequest setFetchLimit:1];
//    
//    NSError *error;
  //  NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    self.cachedResponse = [delegate.urlCache objectForKey:self.request.URL.absoluteString];
    return self.cachedResponse;
//    // TODO: fix old copies where count > 1
//    if (result && result.count > 0) {
//        return result[0];
//    }
//    
//    return nil;
    
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

- (void) saveCachedResponse {
    
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = delegate.managedObjectContext;
    
//   CachedURLResponse *cachedResponse = [NSEntityDescription insertNewObjectForEntityForName:@"CachedURLResponse"
//                                                                     inManagedObjectContext:context];
    self.cachedResponse = [[CachedURLResponse alloc] init];

    self.cachedResponse.data = self.mutableData;
    self.cachedResponse.url = self.request;//.URL.absoluteString;
    self.cachedResponse.timestamp = [NSDate date];
    self.cachedResponse.mimeType = self.response.MIMEType;
    self.cachedResponse.encoding = self.response.textEncodingName;
    self.cachedResponse.response = self.response;
//    
//    NSError *error;
//    [context save:&error];
//    if (error) {
//        NSLog(@"Could not cache the response.");
//    }
    [delegate.urlCache setObject:self.cachedResponse forKey:self.request.URL.absoluteString];
    
    
}

@end
