//
//  RFNetworkManager.m
//  RecentFlickr
//
//  Created by Harsh Shah on 9/30/17.
//  Copyright © 2017 Harsh Shah. All rights reserved.
//

#import "RFNetworkHelper.h"

static NSString * const kFlickrBaseUrl = @"api.flickr.com";
static NSString * const kFlickrServicesPath = @"/services/rest";
static NSString * const kFlickrGetRecentMethod = @"flickr.photos.getRecent";
static NSString * const kFlickrApiKey = @"8ee1ed3ea5f3f1da2db966ad95deefa2";

static const NSInteger kHTTPStatusCodeSuccess = 200;

@implementation RFNetworkHelper

+(void)fetchRecentPhotosWithPageNumber:(NSInteger)pageNumber completion:(void(^)(NSDictionary *response, NSError *error))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [self fetchRecentPhotosUrlWithPageNumber:pageNumber];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        if (urlResponse.statusCode != kHTTPStatusCodeSuccess) {
            error = [NSError errorWithDomain:@"RecentFlickrDomain" code:urlResponse.statusCode userInfo:@{NSLocalizedDescriptionKey : @"Something went wrong, please try again later."}];
            completion(nil, error);
            return;
        }
        
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            completion(nil, error);
            return;
        }
        
        if (!jsonResponse) {
            //TODO: Change error code
            error = [NSError errorWithDomain:@"RecentFlickrDomain" code:urlResponse.statusCode userInfo:@{NSLocalizedDescriptionKey : @"Something went wrong, please try again later."}];
            completion(nil, error);
            return;
        }
        
        completion(jsonResponse, nil);
    }];
    
    [task resume];
}

+(NSURL *)fetchRecentPhotosUrlWithPageNumber:(NSInteger)pageNumber
{
    NSURLComponents *urlComponents = [[NSURLComponents alloc] init];
    urlComponents.scheme = @"https";
    urlComponents.host = kFlickrBaseUrl;
    urlComponents.path = kFlickrServicesPath;
    NSDictionary *queryParams = @{@"method" : kFlickrGetRecentMethod,
                                  @"api_key" : kFlickrApiKey,
                                  @"page" : [@(pageNumber) stringValue],
                                  @"format" : @"json",
                                  @"nojsoncallback" : @"1"
                                  };
    
    NSMutableArray <NSURLQueryItem *> *queryItems = [NSMutableArray array];
    for (NSString *key in queryParams) {
        [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParams[key]]];
    }
    
    urlComponents.queryItems = [queryItems copy];
    return urlComponents.URL;
}

@end
