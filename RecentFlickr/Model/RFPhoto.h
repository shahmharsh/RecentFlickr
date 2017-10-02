//
//  RFPhoto.h
//  RecentFlickr
//
//  Created by Harsh Shah on 9/30/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RFPhoto : NSObject
@property (nonatomic, strong, readonly) NSURL *thumbnailUrl;

+(instancetype)photoFromJson:(NSDictionary *)json;
-(NSDictionary *)json;
@end
NS_ASSUME_NONNULL_END
