//
//  ProfileManager.m
//  Voic
//
//  Created by 杨京蕾 on 10/18/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import "ProfileManager.h"
#import "UserDefaultUtil.h"
#import "SDGridItemCacheTool.h"

@implementation ProfileManager

+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    static id instance = nil;
    
    dispatch_once(&once, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
        _authToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"authToken"];
        _userPhone = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPhone"];
        _voiceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"voiceID"];
    }
    return self;
}

-(BOOL)checkLogin{
    return _authToken.length != 0;
}

- (BOOL)checkVoicePrintExist{
    return _voiceID.length != 0;
}

-(void)logOut{
    self.authToken = @"";
    
    //将数据存放到服务器
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kProfileUserID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kProfileAuthToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kProfileUserPhone];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kProfileVoiceID];
}
-(void)setUserID:(NSString *)userID{
    _userID = userID;
    [[NSUserDefaults standardUserDefaults] setObject:_userID forKey:kProfileUserID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUserPhone:(NSString *)userPhone{
    _userPhone = userPhone;
    [[NSUserDefaults standardUserDefaults] setObject:_userPhone forKey:kProfileUserPhone];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setAuthToken:(NSString *)authToken{
    _authToken = authToken;
    [[NSUserDefaults standardUserDefaults] setObject:_authToken forKey:kProfileAuthToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setVoiceID:(NSString *)voiceID{
    _voiceID = voiceID;
    [[NSUserDefaults standardUserDefaults] setObject:_voiceID forKey:kProfileVoiceID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getUserID{
    return @"1";
    //    return [UserDefaultUtil getObjectBykey:kProfileUserID];
}

-(NSString *)getUserPhone{
    //    return [UserDefaultUtil getObjectBykey:kProfileUserPhone];
    return @"18349201941";
}


-(NSString *)getAuthToken{
    return [UserDefaultUtil getObjectBykey:kProfileAuthToken];
}

-(NSString*)getVoiceID{
    
    NSString* voiceID = [UserDefaultUtil getObjectBykey:kProfileVoiceID];

    return voiceID;
}

- (NSString*)getDeviceID {
    return [UserDefaultUtil getObjectBykey:kProfileDeviceID];
}

- (NSArray *)getAllCommand {
    return [UserDefaultUtil getObjectBykey:kProfileAllCommand];
}

-(void)setGridItems:(NSArray*)gridItems {
    [SDGridItemCacheTool saveItemsArray:gridItems];
}

-(void)setVoiceIDWithSugar {
             NSString* voiceID = [[NSString alloc] initWithString:[kModelSugar stringByAppendingString:[[ProfileManager sharedInstance] getUserPhone]]];
            [[ProfileManager sharedInstance] setVoiceID:voiceID];
}

-(void)setCommand:(NSArray *)command {
    [[NSUserDefaults standardUserDefaults] setObject:command forKey:kProfileAllCommand];
}

@end
