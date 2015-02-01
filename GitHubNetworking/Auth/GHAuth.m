//
//  GHAuth.m
//  GitIssues-iOS
//
//  Created by Logan Wright on 1/28/15.
//  Copyright (c) 2015 LowriDevs. All rights reserved.
//

#import "GHAuth.h"
#import "GHNetworking.h"
#import "NSDictionary+StringInitable.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kAuthorizationBaseUrl = @"https://github.com/login/oauth/authorize";

static NSString * const kAuthorizationKeyClientId = @"client_id";
static NSString * const kAuthorizationKeyClientSecret = @"client_secret";
static NSString * const kAuthorizationKeyRedirectUri = @"redirect_uri";
static NSString * const kAuthorizationKeyScope = @"scope";
static NSString * const kAuthorizationKeyState = @"state";
static NSString * const kAuthorizationKeyCode = @"code";

@interface GHAuth ()
@property (copy, nonatomic) NSString *clientId;
@property (copy, nonatomic) NSString *clientSecret;
@property (copy, nonatomic) NSString *redirectUri;
@property (copy, nonatomic) NSSet *scopes;

//
@property (copy, nonatomic) NSString *state;

//
@property (strong, nonatomic) void (^credentialUpdatedBlock)(GHCredential *, NSError *);
@end

@implementation GHAuth

#pragma mark - Configuration

+ (void)configureGitHubAuthWithClientId:(NSString *)clientId
                           clientSecret:(NSString *)clientSecret
                            redirectURI:(NSString *)redirectURI
                              andScopes:(NSArray *)scopes {
    GHAuth *shared = [self sharedClient];
    shared.clientId = clientId;
    shared.clientSecret = clientSecret;
    shared.redirectUri = redirectURI;
    shared.scopes = [NSSet setWithArray:scopes]; // Remove duplicates
}

#pragma mark - Auth Request

+ (void)authorizeApplicationIfNecessaryWithCompletion:(void (^)(GHCredential *credential, NSError *error))completion {
    NSAssert(completion, @"No completion block == no point");
    
    GHAuth *shared = [self sharedClient];
    [shared setCredentialUpdatedBlock:completion];
    if (sharedCredential) {
        shared.credentialUpdatedBlock(sharedCredential, nil);
    } else {
        NSURL *authUrl = [self authUrl];
#if TARGET_OS_IPHONE
        UIApplication *sharedApplication = [UIApplication sharedApplication];
        if ([sharedApplication canOpenURL:authUrl]) {
            [sharedApplication openURL:authUrl];
        } else {
            NSLog(@"Unable to open authorization url: %@", authUrl);
        }
#else
        [[NSWorkspace sharedWorkspace] openURL:authUrl];
#endif
    }
}

#pragma mark - Auth Response

+ (BOOL)canHandleOpenUrl:(NSURL *)openUrl {
    NSURL *redirectUri = [NSURL URLWithString:[[self sharedClient] redirectUri]];
    return [openUrl.host isEqualToString:redirectUri.host];
}

+ (void)handleOpenUrl:(NSURL *)openUrl {
    [self assertCanOpenURL:openUrl];
    
    NSDictionary *queryParameters = [NSDictionary dictionaryWithUrlQuery:openUrl.query];
    NSString *code = queryParameters[kAuthorizationKeyCode];
    NSString *state = queryParameters[kAuthorizationKeyState];
    
    GHAuth *shared = [GHAuth sharedClient];
    if ([shared.state isEqualToString:state]) {
        NSDictionary *params = @{kAuthorizationKeyClientId : shared.clientId,
                                 kAuthorizationKeyClientSecret : shared.clientSecret,
                                 kAuthorizationKeyCode : code,
                                 kAuthorizationKeyRedirectUri : shared.redirectUri};
        
        [GHNetworking requestAuthCredentialWithParameters:params
                                            andCompletion:^(GHCredential *credential, NSError *error) {
                                                sharedCredential = credential;
                                                shared.credentialUpdatedBlock(credential, error);
                                            }];
    } else {
        NSLog(@"SEC ERROR: Possible attempt at fraudulent authorization!");
        // TODO: Actual Error
        shared.credentialUpdatedBlock(nil, [NSError new]);
    }
}

+ (void)assertCanOpenURL:(NSURL *)url {
    NSString *assertMsg = @"Ensure GHAuth can open a url by calling `[GHAuth canHandleOpenUrl:]`";
    BOOL canOpenUrl = [self canHandleOpenUrl:url];
    NSAssert(canOpenUrl, assertMsg);
}

#pragma mark - Auth URL 

+ (NSURL *)authUrl {
    GHAuth *shared = [GHAuth sharedClient];
    shared.state = [[NSUUID UUID] UUIDString]; // For comparison in resposne
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kAuthorizationKeyClientId] = shared.clientId;
    params[kAuthorizationKeyScope] = [shared.scopes.allObjects componentsJoinedByString:@","];
    params[kAuthorizationKeyRedirectUri] = shared.redirectUri;
    params[kAuthorizationKeyState] = shared.state;
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:kAuthorizationBaseUrl
                                                                         parameters:params
                                                                              error:nil];
    return request.URL;
}

#pragma mark - Singleton

+ (instancetype)sharedClient
{
    static dispatch_once_t onceToken;
    static GHAuth *shared = nil;
    dispatch_once(&onceToken, ^{
        shared = [GHAuth new];
    });
    return shared;
}

#pragma mark - Credential

static GHCredential *sharedCredential = nil;

+ (GHCredential *)currentCredential {
    return sharedCredential;
}

+ (void)setCurrentCredential:(GHCredential *)credential {
    @synchronized(self) {
        sharedCredential = credential;
    }
}



@end
