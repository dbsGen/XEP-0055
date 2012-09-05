//
//  XMPPSearchResault.h
//  SOP2p
//
//  Created by zrz on 12-8-18.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"
#import "XMPPSearchNode.h"

@interface XMPPSearchResult : NSObject

@property (nonatomic, readonly) NSArray     *singleFields,
                                            *tableFields;

@property (nonatomic, readonly) NSString    *singleInstructions,
                                            *tableInstructions;

- (id)initWithElement:(NSXMLElement *)element;
+ (id)resaultWithElement:(NSXMLElement *)element;

// Copy fields from template.
- (NSArray *)copyForSingleFields;
- (NSArray *)copyForTableFields;

@end
