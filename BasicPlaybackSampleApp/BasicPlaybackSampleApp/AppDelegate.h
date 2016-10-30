//
//  AppDelegate.h
//  AdvancedPlaybackSampleApp
//
//  Copyright (c) 2015 Ooyala, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//A counter for tracking the number of ooyala sdk events generated across all the test asset plays
@property (nonatomic,assign) int count;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMutableDictionary *urlCache;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

