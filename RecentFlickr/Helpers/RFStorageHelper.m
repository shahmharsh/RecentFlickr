//
//  RFStorageManager.m
//  RecentFlickr
//
//  Created by Harsh Shah on 9/30/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import "RFStorageHelper.h"
#import "RFPhoto.h"

static NSString * const kLastFetchedPageKey = @"RFLastFetchedPageKey";
static NSString * const kTotalPagesKey = @"RFTotalPagesKey";
static NSString * const kSavedPhotosKey = @"RFSavedPhotosKey";

@implementation RFStorageHelper

+(void)saveLastFetchedPage:(NSInteger)pageNumber
{
    [[NSUserDefaults standardUserDefaults] setInteger:pageNumber forKey:kLastFetchedPageKey];
}

+(NSInteger)getLastFetchedPage
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kLastFetchedPageKey];
}

+(void)saveTotalPages:(NSInteger)totalPages
{
    [[NSUserDefaults standardUserDefaults] setInteger:totalPages forKey:kTotalPagesKey];
}

+(NSInteger)getTotalPages
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kTotalPagesKey];
}


+(void)savePhotos:(NSArray <RFPhoto *> *)photos
{
    NSMutableArray <NSDictionary *> *photosJsonArray = [NSMutableArray arrayWithCapacity:photos.count];
    for (RFPhoto *photo in photos) {
        [photosJsonArray addObject:[photo json]];
    }
    
    NSMutableArray *allPhotos = [[self savedPhotos] mutableCopy];
    if (!allPhotos.count) {
        allPhotos = [NSMutableArray arrayWithCapacity:photos.count];
    }
    
    [allPhotos addObjectsFromArray:[photosJsonArray copy]];
    [[NSUserDefaults standardUserDefaults] setValue:allPhotos forKey:kSavedPhotosKey];
}

+(NSArray <RFPhoto *> *)getSavedPhotos
{
    NSArray <NSDictionary *> *savedPhotos = [self savedPhotos];
    NSMutableArray <RFPhoto *> *photos = [NSMutableArray arrayWithCapacity:savedPhotos.count];
    for (NSDictionary *json in savedPhotos) {
        [photos addObject:[RFPhoto photoFromJson:json]];
    }
    
    return [photos copy];
}

+(NSArray <NSDictionary *> *)savedPhotos
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:kSavedPhotosKey];
}
@end
