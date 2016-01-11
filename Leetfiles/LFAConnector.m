//
//  LFAConnector.m
//  Leetfiles
//
//  Created by Guillermo Moran on 1/23/15.
//  Copyright (c) 2015 Fr0st Development. All rights reserved.
//

#import "LFAConnector.h"

#import "LFAMacros.h"

#import "UAObfuscatedString.h"
#import "NSString+LFAEncrypt.h"

#import "Reachability.h"

@implementation LFAConnector

static NSString* secretKey;

+(NSString*)uploadImage:(UIImage*)image withAPIKey:(NSString*)apiKey {
    
    
    
    // COnvert Image to NSData
    NSString *urlString = @"https://leetfil.es/api/upload/image";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    //[request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // file
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@.jpg\"\r\n", @"MobileUpload"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Text parameter1
    NSString *param1 = apiKey;
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"apikey\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:param1] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    /*
     // Another text parameter
     NSString *param2 = @"Parameter 2 text";
     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"parameter2\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithString:param2] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     */
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    // Get Response of Your Request
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    
    
    if ([responseString hasPrefix:@"leetfil.es"]) {
        responseString = [NSString stringWithFormat:@"https://%@", responseString];
    }
    
    
    
    return responseString;
    
}

+(NSString*)uploadPaste:(NSString*)paste withAPIKey:(NSString*)apiKey {
    
    /*
     Plain Text - no-highlight
     Apache - apache
     Bash - bash
     C - c
     C# - cs
     C++ - cpp
     CSS - css
     CoffeeScript - coffeescript
     HTML - html
     Ini - ini
     Java - java
     JavaScript - javascript
     Objective C - objectivec
     PHP - php
     Perl - perl
     Python - python
     Ruby - ruby
     SQL - sql
     XML - xml
    */
    
    NSString* url = @"https://leetfil.es/api/upload/paste";
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"pastedata=%@&language=no-highlight&apikey=%@", paste, apiKey] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestBody];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    
    if (!result || [result isEqualToString:@""]) {
        result = @"An error occured.";
    }
    
    return result;
}

+(NSArray*)userInfo:(NSString*)apiKey {
    
    /*
     Documentation:
     
     Example Usage: (index is 0 for limits, 1 for used space)
     
     NSArray* limitArray = [results valueForKey:@"f_storage"];
     int limit = [[limitArray objectAtIndex:0] intValue];
     
     Values: 
     
     File Storage: f_storage (0), f_storage_used (1)
     Image Storage: i_storage(0), i_storage_used (1)
     Paste Limits: p_limit (0), p_limit_used (1)
     
     
    */
    
    
    
    NSString* url = @"https://leetfil.es/api/usage/info";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"apikey=%@", apiKey] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestBody];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    
    NSError *parseError = nil;
    
    id object = [NSJSONSerialization
                 JSONObjectWithData:responseData
                 options:0
                 error:&parseError];
    
    if(perror) { }
    
    
    if([object isKindOfClass:[NSArray class]])
    {
        NSArray *results = object;
        
        //NSLog(@"%@", results);
        
        return results;
    }
    return nil;
}

+(void)logOut {
    [KeychainManager deleteStringForKey:Obfuscate.l.e.e.t.f.i.l.e.s.u.s.e.r];
    [KeychainManager deleteStringForKey:Obfuscate.l.e.e.t.f.i.l.e.s.p.a.s.s];
}

+(BOOL)isLoggedIn {
    
    NSLog(@"Checking Log In state...");
    
    if (![keyForUser(LFA_KEYCHAIN_USER, LFA_KEYCHAIN_PASS) isEqualToString:@"Invalid Login"]) {
        NSLog(@"User is logged in");
        return YES;
    }
    NSLog(@"User is not logged in.");
    return NO;
    
}

+(NSString*)userAPIKeyForUsername:(NSString*)username Password:(NSString*)password {
    
    NSLog(@"Fetching API Key for %@", username);
    
    secretKey = Obfuscate.plus.pound.forward_slash.semicolon.exclamation;
    
    
    NSString* url = Obfuscate.h.t.t.p.s.colon.forward_slash.forward_slash.l.e.e.t.f.i.l.dot.e.s.forward_slash.a.p.i.forward_slash.v.a.l.i.d.a.t.e.forward_slash.u.s.e.r;
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"username=%@&password=%@", username, password] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestBody];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
   NSString* badLogInKey = Obfuscate._9.e._3._0._4.d._4.e._8.d.f._1.b._7._4.c.f.a._0._0._9._9._1._3._1._9._8._4._2._8.a.b;
    
    /*
    if ([result isEqualToString:badLogInKey]) {
        result = @"Invalid Login";
    }
     */
    
    if ([self isValidAPIKey: result] && ![result isEqualToString:badLogInKey]) {
        return result;
    }
    else {
        return @"Invalid Login";
    }
}

+(BOOL)isValidAPIKey:(NSString*)apiKey {
    
    NSLog(@"Validating API Key...");
    
    NSString* url = @"https://leetfil.es/api/validate/key";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSData *requestBody = [[NSString stringWithFormat:@"apikey=%@", apiKey] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestBody];
    
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
    
    if ([result isEqualToString:@"1"]) {
        NSLog(@"Key is valid");
        return YES;
    }
    
    else {
        NSLog(@"Key is invalid");
        return NO;
    }

}

+(BOOL)isConnectedToTheInternet {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable) {
        return NO;
    }
    
    return YES;
}

@end