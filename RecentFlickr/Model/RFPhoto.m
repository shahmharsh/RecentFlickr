//
//  RFPhoto.m
//  RecentFlickr
//
//  Created by Harsh Shah on 9/30/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import "RFPhoto.h"

static NSString * const kTitleKey = @"title";
static NSString * const kFamIdKey = @"farm";
static NSString * const kServerIdKey = @"server";
static NSString * const kPhotoIdKey = @"id";
static NSString * const kSecretKey = @"secret";

@interface RFPhoto()
@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSInteger farmId;
@property (nonatomic, copy) NSString *serverId;
@property (nonatomic, copy) NSString *photoId;
@property (nonatomic, copy) NSString *secret;
@end

@implementation RFPhoto
-(instancetype)initWithTitle:(NSString *)title
                      farmId:(NSInteger)farmId
                    serverId:(NSString *)serverId
                     photoId:(NSString *)photoId
                      secret:(NSString *)secret
{
    self = [super init];
    if (self) {
        self.title = title;
        self.farmId = farmId;
        self.serverId = serverId;
        self.photoId = photoId;
        self.secret = secret;
    }
    
    return self;
}

+(instancetype)photoFromJson:(NSDictionary *)json
{
    NSString *title = json[kTitleKey];
    NSInteger farmId = [json[kFamIdKey] integerValue];
    NSString *serverId = json[kServerIdKey];
    NSString *photoId = json[kPhotoIdKey];
    NSString *secret = json[kSecretKey];
    RFPhoto *photo = [[RFPhoto alloc] initWithTitle:title farmId:farmId serverId:serverId photoId:photoId secret:secret];
    return photo;
}

-(NSDictionary *)json
{
    return @{kTitleKey : self.title,
             kFamIdKey : [@(self.farmId) stringValue],
             kServerIdKey : self.serverId,
             kPhotoIdKey : self.photoId,
             kSecretKey : self.secret
             };
}

-(NSURL *)thumbnailUrl
{
    //FORMAT: https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_t.jpg
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"https";
    urlComponents.host = [NSString stringWithFormat:@"farm%ld.staticflickr.com", self.farmId];
    urlComponents.path = [NSString stringWithFormat:@"/%@/%@_%@_t.jpg", self.serverId, self.photoId, self.secret];
    return urlComponents.URL;
}

@end
