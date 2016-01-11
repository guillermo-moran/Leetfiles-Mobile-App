//
//  NSString+LFAEncrypt.h
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LFAEncrypt)

+ (NSString *)obfuscate:(NSString *)string withKey:(NSString *)key;

@end
