//
//  RFStorageManager.h
//  RecentFlickr
//
//  Created by Harsh Shah on 9/30/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RFPhoto;
@interface RFStorageHelper : NSObject

+(void)saveLastFetchedPage:(NSInteger)pageNumber;
+(NSInteger)getLastFetchedPage;

+(void)saveTotalPages:(NSInteger)totalPages;
+(NSInteger)getTotalPages;

+(void)savePhotos:(NSArray <RFPhoto *> *)photos;
+(NSArray <RFPhoto *> *)getSavedPhotos;

@end
NS_ASSUME_NONNULL_END
