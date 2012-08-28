//
//  XMPPSearchReported.h
//  SOP2p
//
//  Created by zrz on 12-8-19.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "XMPPSearchNode.h"

@interface XMPPSearchReported : NSObject

@property (nonatomic, strong)   NSArray *reporteds, //reported is XMPP
                                        *items;     //items is NSDictionary

+ (id)reportWithElement:(NSXMLElement *)element;
- (NSXMLElement *)xmlElement;

@end
