//
//  RFNetworkManager.h
//  RecentFlickr
//
//  Created by Harsh Shah on 9/30/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface RFNetworkHelper : NSObject

+(void)fetchRecentPhotosWithPageNumber:(NSInteger)pageNumber completion:(void(^)(NSDictionary *response, NSError *error))completion;

@end
NS_ASSUME_NONNULL_END
