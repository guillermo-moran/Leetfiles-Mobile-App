//
//  LFAConnector.h
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LFAConnector : NSObject {

    NSMutableData *_responseData;
    
}

+(BOOL)isValidAPIKey:(NSString*)apiKey;

+(NSString*)userAPIKeyForUsername:(NSString*)username Password:(NSString*)password;

+(NSArray*)userInfo:(NSString*)apiKey;

+(NSString*)uploadImage:(UIImage*)image withAPIKey:(NSString*)apiKey;
+(NSString*)uploadPaste:(NSString*)paste withAPIKey:(NSString*)apiKey;

+(BOOL)isLoggedIn;
+(void)logOut;

+(BOOL)isConnectedToTheInternet;

@end