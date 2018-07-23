//
//  JSBridgeConfig.m
//  Pods
//
//  Created by david on 16/4/8.
//
//

#import "JSBridgeConfig.h"

static NSString *const prefix = @";(function() { var jsbridge = window.CPJsBridge; window.CPJsApi = {";
static NSString *const suffix = @"};})();";

@interface JSBridgeConfig ()

@property (nonatomic, strong) NSMutableDictionary *serviceConfigDict;
@property (nonatomic, strong) NSMutableDictionary *jsApiConfigDict;

@end

@implementation JSBridgeConfig

+ (instancetype)sharedInstance
{
    static JSBridgeConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JSBridgeConfig alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _serviceConfigDict = [NSMutableDictionary dictionary];
        _jsApiConfigDict = [NSMutableDictionary dictionary];
        
    }
    return self;
}

- (void)registerJSApi:(NSString *)domain service:(NSString *)clsName selectors:(NSArray<NSArray *> *)sels local:(BOOL)isLocal
{
    if (!domain|| !clsName || ![sels count]) {
        return;
    }
    
    NSMutableArray *jsApiAray = self.jsApiConfigDict[domain];
    NSMutableArray *jsApiList = nil;
    if (!jsApiAray || ![jsApiAray count]) {
        jsApiList = [NSMutableArray array];
        self.jsApiConfigDict[domain] = jsApiList;
    } else {
        jsApiList = jsApiAray;
    }
    
    NSDictionary *serviceDict = self.serviceConfigDict[clsName];
    NSMutableArray *exportList = nil;
    if (!serviceDict) {
        exportList = [NSMutableArray array];
        self.serviceConfigDict[clsName] = @{@"domain":clsName,
                                            @"islocal":@(isLocal),
                                            @"exports":exportList};
    } else {
        exportList = self.serviceConfigDict[clsName][@"exports"];
    }
    
    [sels enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]] && [obj count] >= 2 ) {
            
            NSNumber *level = [obj firstObject];
            NSString *showName = obj[1];
            NSString *realName = [obj lastObject];
            NSDictionary *export = @{@"level":level,
                                     @"showname":showName,
                                     @"realname":realName};
            
            if (![jsApiList containsObject:showName]) {
                [jsApiList addObject:showName];
            }
            
            if (![exportList containsObject:export]) {
                [exportList addObject:export];
            }
        }
    }];
}

- (NSArray *)serviceConfig
{
    return [[self.serviceConfigDict allValues] copy];
}

- (NSString *)jsApi
{
    if (![self.jsApiConfigDict count]) {
        return nil;
    }
    
    NSMutableString *jsApiString = [NSMutableString string];
    [jsApiString appendString:prefix];
    
    [self.jsApiConfigDict enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull domain, NSArray *  _Nonnull funcs, BOOL * _Nonnull stop) {
        NSMutableString *domainString = [NSMutableString stringWithFormat:@"%@ : {",domain];
        [funcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *string = [NSString stringWithFormat:@"%@ : function(params, callback){jsbridge.invoke('%@', params, callback);}",obj,obj];
            [domainString appendString:string];
            if (idx < [funcs count]-1) {
                [domainString appendString:@","];
            }
        }];
        [domainString appendString:@"},"];
        [jsApiString appendString:domainString];
    }];
    
    [jsApiString appendString:suffix];
    
    return [jsApiString copy];
}

- (void)resignAllConfig
{
    [self.serviceConfigDict removeAllObjects];
    [self.jsApiConfigDict removeAllObjects];
}

/***** CPJSApi.js.text ****
 ;(function() {
 var jsbridge = window.CPJsBridge;
 
 window.CPJsApi = {
                common : {
                    isappinstalled : function(params, callback){
                        jsbridge.invoke('isappinstalled', params, callback);
                    },
                    openurl : function(params, callback){
                        jsbridge.invoke('openurl', params, callback);
                    },
                    onPostNotification : function(params, callback){
                        jsbridge.invoke('onPostNotification', params, callback);
                    }
                },
                account : {
                    login : function(params, callback){
                        jsbridge.invoke('login', params, callback);
                    },
                    onCookieFinished : function(params, callback){
                        jsbridge.invoke('onCookieFinished', params, callback);
                    },
                    recharge: function(params, callback){
                        jsbridge.invoke('recharge', params, callback);
                    }
                },
                ui : {
                    setOptionMenu : function(params, callback){
                        jsbridge.invoke('setOptionMenu', params, callback);
                    },
                    setNativeOptionMenu : function(params, callback){
                        jsbridge.invoke('setNativeOptionMenu', params, callback);
                    },
                    setToolbarMenu : function(params, callback){
                        jsbridge.invoke('setToolbarMenu', params, callback);
                    }
                },
                activity : {
                    close : function(params, callback){
                        jsbridge.invoke('close', params, callback);
                    }
                },
                share : {
                    onshare : function(params, callback){
                        jsbridge.invoke('onshare', params, callback);
                    }
                }
            };
 })();
 

 ********serviceConfig.json******
 {
 "services": [
 {
 "domain": "CPBridgeBetService",
 "exports": [
 {
 "showname": "matchbet",
 "realname": "matchBet",
 "level": 0
 },
 {
 "showname": "numberbet",
 "realname": "numberBet",
 "level": 0
 }
 ],
 "islocal": true
 },
 {
 "domain": "CPBridgeCommonService",
 "exports": [
 {
 "showname": "openurl",
 "realname": "openUrl",
 "level": 0
 },
 {
 "showname": "isappinstalled",
 "realname": "isAppInstalled",
 "level": 0
 },
 {
 "showname": "onPostNotification",
 "realname": "onPostNotification",
 "level": 0
 }
 ],
 "islocal": true
 },
 {
 "domain": "CPBridgeLoginService",
 "exports": [
 {
 "showname": "login",
 "realname": "login",
 "level": 0
 },
 {
 "showname": "onCookieFinished",
 "realname": "onCookieFinished",
 "level": 0
 }
 ],
 "islocal": true
 },
 {
 "domain": "CPBridgeShareService",
 "exports": [
 {
 "showname": "onshare",
 "realname": "onShare",
 "level": 0
 }
 ],
 "islocal": true
 },
 {
 "domain": "HYGBridgeRechargeService",
 "exports": [
 {
 "showname": "recharge",
 "realname": "recharge",
 "level": 0
 }
 ],
 "islocal": true
 },
 {
 "domain": "CPBridgeUIService",
 "exports": [
 {
 "showname": "setOptionMenu",
 "realname": "setOptionMenu",
 "level": 0
 },
 {
 "showname": "setNativeOptionMenu",
 "realname": "setNativeOptionMenu",
 "level": 0
 },
 {
 "showname": "setToolbarMenu",
 "realname": "setToolbarMenu",
 "level": 0
 }
 ],
 "islocal": true
 },
 {
 "domain": "CPBridgePageService",
 "exports": [
 {
 "showname": "close",
 "realname": "close",
 "level": 0
 }
 ],
 "islocal": true
 }
 ]
 }
 
 */

@end
