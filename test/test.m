//
//  test.m
//  test
//
//  Created by zrz on 12-9-9.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "test.h"

@implementation test

- (id)init
{
    self = [super init];
    if (self) {
        _stream = [[XMPPStream alloc] init];
        _stream.hostName = @"SERVER";
        _stream.hostPort = 5222;
        _stream.myJID = [XMPPJID jidWithString:@"USER_ID"];
        [_stream addDelegate:self
               delegateQueue:dispatch_get_main_queue()];
        
        _searchModule = [[XMPPSearchModule alloc] initWithDispatchQueue:dispatch_get_current_queue()];
        _searchModule.searchHost = @"SEARCH_SERVER";
        [_searchModule activate:_stream];
        [_searchModule addDelegate:self
                     delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)askForFields
{
    [_searchModule askForFields];
}

- (void)search
{
    XMPPSearchSingleNode *search = [[XMPPSearchSingleNode alloc] init];
    search.name = @"nickname";
    search.value = @"z";
    [_searchModule searchWithFields:@[search]
                           userData:nil];
}

- (void)connect
{
    NSError *err = nil;
    [_stream connectWithTimeout:10
                          error:&err];
    if (err) {
        NSLog(@"Got a error when connect to the server . %@", err);
    }
}

- (void)searchModel:(XMPPSearchModule*)searchModul result:(XMPPSearchReported*)result userData:(id)userData
{
    NSLog(@"search result : %@", result);
}

- (void)searchModelGetFields:(XMPPSearchModule *)searchModul
{
    NSLog(@"Get fields : %@", searchModul.result);
}

- (void)xmppStreamDidConnect:(XMPPStream *)stream
{
    NSError *error = nil;
    if (![stream authenticateWithPassword:@"PASSWORD"
                                    error:&error])
    {
        DDLogError(@"Error authenticating: %@", error);
    }
}

@end
