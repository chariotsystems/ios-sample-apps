//
//  AppDelegate.h
//  AdvancedPlaybackSampleApp
//
//  Copyright (c) 2015 Ooyala, Inc. All rights reserved.
//
/**
 * includes changes by:
 * User: alex eadie
 * Date: 1/11/2016
 * Copyright (c) 2016, Telstra.
 * This is proprietary information of the Telstra Corporation Limited.
 * Copying or reproduction without prior written approval is prohibited.
 **/

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//A counter for tracking the number of ooyala sdk events generated across all the test asset plays
@property (nonatomic,assign) int count;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSDate* lastPurgeDate;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

