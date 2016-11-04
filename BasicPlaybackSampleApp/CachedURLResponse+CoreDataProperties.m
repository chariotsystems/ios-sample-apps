//
//  CachedURLResponse+CoreDataProperties.m
//  BasicPlaybackSampleApp
//
//  Created by admin on 5/11/16.
//  Copyright © 2016 Ooyala, Inc. All rights reserved.
//

#import "CachedURLResponse+CoreDataProperties.h"

@implementation CachedURLResponse (CoreDataProperties)

+ (NSFetchRequest<CachedURLResponse *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CachedURLResponse"];
}

@dynamic data;
@dynamic encoding;
@dynamic mimeType;
@dynamic timestamp;
@dynamic url;

@end
