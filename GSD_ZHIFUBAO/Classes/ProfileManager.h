//
//  ProfileManager.h
//  Voic
//
//  Created by 杨京蕾 on 10/18/16.
//  Copyright © 2016 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileManager : NSObject

@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* userPhone;
@property (strong, nonatomic) NSString* authToken;
@property (strong, nonatomic) NSString* voiceID;

+ (instancetype)sharedInstance;

- (BOOL)checkLogin;

- (BOOL)checkVoicePrintExist;

- (void)logOut;

- (NSString*)getUserID;

- (NSString*)getUserPhone;

- (NSString*)getAuthToken;

- (NSString*)getVoiceID;

-(void)setUserID:(NSString *)userID;

-(void)setUserPhone:(NSString *)userPhone;

-(void)setAuthToken:(NSString *)authToken;

-(void)setVoiceID:(NSString *)voiceID;

-(void)setGridItems:(NSArray*)gridItems;

@end
