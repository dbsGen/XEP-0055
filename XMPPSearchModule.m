//
//  XMPPSearchModule.m
//  SOP2p
//
//  Created by zrz on 12-8-7.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import "XMPP.h"
#import "XMPPSearchModule.h"
#import "XMPPIQ.h"
#import "XMPPStream.h"
#import "XMPPJID.h"
#import "XMPPSearchNode.h"

#define kSearchNamespace        @"jabber:iq:search"
#define kSearchXDataNamespace   @"jabber:x:data"

static const id kSearchFieldResault = @"searchResault";
static const id kSearchFieldNull    = @"searchNull";

@implementation XMPPSearchModule

@synthesize searchHost = _searchHost, result = _result;

#pragma mark - init

- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
    self = [super initWithDispatchQueue:queue];
    if (self) {
        _searchUserDatas = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public

//setter of searchHost.
- (void)setSearchHost:(NSString *)searchHost
{
    if (![searchHost isEqualToString:_searchHost]) {
        _searchHost = searchHost;
        _result = nil;
    }
}

- (void)searchWithFields:(NSArray*)fields
                userData:(id)userData
{
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addNamespace:[NSXMLNode namespaceWithName:@""
                                          stringValue:kSearchNamespace]];
    __block NSXMLElement *x = nil;
    [fields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XMPPSearchNode *node = obj;
        XMPPSearchNodeType type = node.valueType;
        if (type == kXMPPSearchNodeTypeUnknown ||
            type == kXMPPSearchNodeTypeHidden) {
            return ;
        }
        if ([node isKindOfClass:[XMPPSearchSingleNode class]]) {
            [query addChild:[node xmlElment]];
        }else {
            if (!x) {
                x = [NSXMLElement elementWithName:@"x"
                                         children:nil
                                       attributes:@[[NSXMLNode attributeWithName:@"type" stringValue:@"submit"]]];
                [x addNamespace:[NSXMLNode namespaceWithName:nil
                                                 stringValue:@"jabber:x:data"]];
                [query addChild:x];
            }
            
            //don't send the hidden value.
            if (node.valueType != kXMPPSearchNodeTypeHidden) {
                NSXMLElement *e = [node xmlElment];
                if (e) [x addChild:e];
            }
        }
    }];
    
    NSString *eid = self.xmppStream.generateUUID;
    XMPPIQ *iq = [XMPPIQ iqWithType:@"set"
                                 to:[XMPPJID jidWithString:_searchHost]
                          elementID:eid
                              child:query];
//    
//    [iq addAttribute:[NSXMLNode attributeWithName:@"to"
//                                      stringValue:_searchHost]];
    NSLog(@"%@", iq.XMLString);
    
    [self.xmppStream sendElement:iq];
    
    if (userData)
        [_searchUserDatas setObject:userData
                             forKey:eid];
    else [_searchUserDatas setObject:kSearchFieldNull
                              forKey:eid];
}

- (void)askForFields
{
    if (!_searchHost) {
        NSLog(@"Must set a search host.");
        return;
    }
    NSXMLElement *query = [NSXMLElement elementWithName:@"query"];
    [query addNamespace:[NSXMLNode namespaceWithName:@""
                                         stringValue:kSearchNamespace]];
    NSString *eid = self.xmppStream.generateUUID;
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get"
                                 to:[XMPPJID jidWithString:_searchHost]
                          elementID:eid
                              child:query];
    
    [self.xmppStream sendElement:iq];
    [_searchUserDatas setObject:kSearchFieldResault
                         forKey:eid];
}

#pragma mark - private

- (NSXMLElement*)elementWithSerchTarget:(NSString*)name value:(NSString*)value
{
    NSXMLElement *e = [NSXMLElement elementWithName:@"field"];
    [e addAttribute:[NSXMLNode attributeWithName:@"var"
                                     stringValue:name]];
    [e addChild:[NSXMLElement elementWithName:@"value"
                                  stringValue:@"1"]];
    return e;
}

#pragma mark - receive iq

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    
    NSXMLElement *query = [iq elementForName:@"query"
                                       xmlns:@"jabber:iq:search"];
    if (query) {
        // call back
        id eid = iq.elementID;
        id obj = [_searchUserDatas objectForKey:eid];
        if (!obj) {
            return NO;
        }
        if (obj == kSearchFieldResault) {
            _result = [XMPPSearchResult resaultWithElement:iq];
            [self->multicastDelegate searchModelGetFields:self];
        }else if (obj != kSearchFieldNull) {
            [self->multicastDelegate searchModel:self
                                          result:[XMPPSearchReported reportWithElement:iq]
                                        userData:obj];
        }else {
            [self->multicastDelegate searchModel:self
                                          result:[XMPPSearchReported reportWithElement:iq]
                                        userData:nil];
        }
        [_searchUserDatas removeObjectForKey:eid];
    }
    return NO;
}


@end
