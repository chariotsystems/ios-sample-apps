//
//  CachedURLResponse+CoreDataProperties.h
//  BasicPlaybackSampleApp
//
//  Created by admin on 5/11/16.
//  Copyright © 2016 Ooyala, Inc. All rights reserved.
//

#import "CachedURLResponse+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CachedURLResponse (CoreDataProperties)

+ (NSFetchRequest<CachedURLResponse *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *data;
@property (nullable, nonatomic, copy) NSString *encoding;
@property (nullable, nonatomic, copy) NSString *mimeType;
@property (nullable, nonatomic, copy) NSDate *timestamp;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
