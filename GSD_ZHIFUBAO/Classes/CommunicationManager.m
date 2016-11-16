//
//  CommunicationManager.m
//  Voic
//
//  Created by 杨京蕾 on 10/19/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "CommunicationManager.h"
#import "RequestPackUtil.h"
#import "HTTPUtil.h"

@implementation CommunicationManager

+(void)registerWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(BOOL, NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure{
    NSString* _url = kUrlUserRegister;
    NSString* _password = [password MD5String];
    NSDictionary* _data = [NSDictionary dictionaryWithObjectsAndKeys:
                           phone, @"phone",
                           _password ,@"password",
                           nil];
    NSDictionary* _param = [RequestPackUtil packWithData: _data];
    [[HTTPUtil sharedInstance] POST:_url parameters:_param progress:nil success:^(NSURLSessionDataTask* task, id response){
        NSLog(@"Response: %@", response);
        BOOL result = [[response objectForKey:kResponseResultCode] boolValue];
        NSString* message = [response objectForKey:kResponseMessageKey];
        NSDictionary* data = [response objectForKey:kDataKey];
        success(result, message, data);
    }failure:^(NSURLSessionDataTask* task, NSError* error){
        NSLog(@"Error: %@", error);
    }];
}

+(void)loginWithPhone:(NSString *)phone password:(NSString *)password success:(void (^)(BOOL, NSString *, NSDictionary*))success failure:(void (^)(NSError *))failure{
    NSString* _url = kUrlUserLogin;
    NSString* _password = [password MD5String];
    NSDictionary* _data = [NSDictionary dictionaryWithObjectsAndKeys:
                           phone, @"phone",
                           _password ,@"password",
                           nil];
    NSDictionary* _param = [RequestPackUtil packWithData: _data];
    [[HTTPUtil sharedInstance] POST:_url parameters:_param progress:nil success:^(NSURLSessionDataTask* task, id response){
        NSLog(@"Response: %@", response);
        BOOL result = [[response objectForKey:kResponseResultCode] boolValue];
        NSString* message = [response objectForKey:kResponseMessageKey];
        NSDictionary* data = [response objectForKey:kDataKey];
        success(result, message, data);
    }failure:^(NSURLSessionDataTask* task, NSError* error){
        NSLog(@"Error: %@", error);
    }];}

+ (void)addDeviceWithTitle:(NSString *)title image:(NSString *)img_res_string currentStat:(NSNumber *)current_stat colorStatPair:(NSDictionary *)color_stat_pair success:(void (^)(BOOL, NSString *, NSDictionary *))success failure:(void (^)(NSError *))failure {
    NSString* _url = kUrlAddDevice;
    NSDictionary* _data = [NSDictionary dictionaryWithObjectsAndKeys:title, @"title", img_res_string, @"img_res_string", current_stat, @"current_stat", color_stat_pair, @"color_stat_pair", nil];
    
    NSDictionary* _param = [RequestPackUtil packWithData:_data];
    [[HTTPUtil sharedInstance] POST:_url parameters:_param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        NSLog(@"Response: %@", response);
        BOOL result = [[response objectForKey:kResponseResultCode] boolValue];
        NSString* message = [response objectForKey:kResponseMessageKey];
        NSDictionary* data = [response objectForKey:kDataKey];
        success(result, message, data);
    }failure:^(NSURLSessionDataTask* task, NSError* error){
        NSLog(@"Error: %@", error);
    }];
}

@end
