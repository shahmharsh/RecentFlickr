//
//  RFPhotosList.h
//  RecentFlickr
//
//  Created by Harsh Shah on 9/30/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RFPhoto;
@interface RFPhotosManager : NSObject
@property (nonatomic, strong, readonly) NSArray <RFPhoto *> *allPhotos;
@property (nonatomic, readonly) BOOL allPhotosFetched;

+(RFPhotosManager *)sharedManager;
-(void)fetchMorePhotosWithCompletion:(void(^)(NSArray <RFPhoto *> *photos, NSError *error))completion;
@end
NS_ASSUME_NONNULL_END
