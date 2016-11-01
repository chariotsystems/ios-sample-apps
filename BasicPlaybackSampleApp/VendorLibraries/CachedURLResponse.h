/**
 * CachedURLResponse.h
 *
 * User: alex eadie
 * Date: 1/11/2016
 * Copyright (c) 2016, Telstra.
 * This is proprietary information of the Telstra Corporation Limited.
 * Copying or reproduction without prior written approval is prohibited.
 *
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CachedURLResponse : NSManagedObject

@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSString * encoding;
@property (nonatomic, retain) NSData * data;


@end
