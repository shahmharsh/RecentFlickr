//
//  RFPhotosList.m
//  RecentFlickr
//
//  Created by Harsh Shah on 9/30/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import "RFPhotosManager.h"
#import "RFNetworkHelper.h"
#import "RFStorageHelper.h"
#import "RFPhoto.h"

@interface RFPhotosManager()
@property (nonatomic) NSInteger lastPageFetched;
@property (nonatomic) NSInteger totalPages;
@property (nonatomic, strong) NSArray <RFPhoto *> *allPhotos;
@end

@implementation RFPhotosManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.lastPageFetched = [RFStorageHelper getLastFetchedPage];
        self.totalPages = [RFStorageHelper getTotalPages];
        self.allPhotos = [RFStorageHelper getSavedPhotos];
    }
    return self;
}

+(RFPhotosManager *)sharedManager
{
    static RFPhotosManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[RFPhotosManager alloc] init];
    });
    
    return sharedManager;
}

-(void)fetchMorePhotosWithCompletion:(void(^)(NSArray <RFPhoto *> *photos, NSError *error))completion
{
    if (self.allPhotosFetched) {
        // Do not make more network calls since no more photos left
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSInteger pageToFetch = self.lastPageFetched + 1;
    [RFNetworkHelper fetchRecentPhotosWithPageNumber:pageToFetch completion:^(NSDictionary * _Nonnull response, NSError * _Nonnull error) {
        __strong typeof (self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        strongSelf.lastPageFetched = pageToFetch;
        [RFStorageHelper saveLastFetchedPage:strongSelf.lastPageFetched];
        strongSelf.totalPages = [[response valueForKeyPath:@"photos.pages"] integerValue];
        [RFStorageHelper saveTotalPages:strongSelf.totalPages];
        [strongSelf addPhotosFromArray:[response valueForKeyPath:@"photos.photo"]];
        completion(strongSelf.allPhotos, nil);
    }];
}

-(BOOL)allPhotosFetched
{
    // All photos have been fetched when last page has been fetched
    return self.lastPageFetched > 0 && self.lastPageFetched == self.totalPages;
}

-(void)addPhotosFromArray:(NSArray *)photosArray
{
    NSMutableArray <RFPhoto *> *mutablePhotos = [NSMutableArray arrayWithCapacity:photosArray.count];
    for (NSDictionary *photoJson in photosArray) {
        RFPhoto *photo = [RFPhoto photoFromJson:photoJson];
        [mutablePhotos addObject:photo];
    }
    
    NSArray <RFPhoto *> *photos = [mutablePhotos copy];
    [RFStorageHelper savePhotos:photos];
    
    NSMutableArray <RFPhoto *> *allPhotos = [NSMutableArray arrayWithArray:self.allPhotos];
    [allPhotos addObjectsFromArray:photos];
    self.allPhotos = [allPhotos copy];
}
@end
