//
//  XMPPSearchResault.m
//  SOP2p
//
//  Created by zrz on 12-8-18.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import "XMPPSearchResult.h"

@implementation XMPPSearchResult

@synthesize singleFields = _singleFields, tableFields = _tableFields;
@synthesize singleInstructions = _singleInstructions;
@synthesize tableInstructions = _tableInstructions;

- (id)initWithElement:(NSXMLElement *)element
{
    self = [super init];
    if (self) {
        NSXMLElement *query = [[element elementsForName:@"query"] lastObject];
        NSString *type = [[element attributeForName:@"type"] stringValue];
        _singleInstructions = [[[query elementsForName:@"instructions"] lastObject] stringValue];
        if ([type isEqualToString:@"result"]) {
            NSArray *queryChildren = [query children];
            NSMutableArray *nFields = [NSMutableArray array];
            NSMutableArray *tFields = [NSMutableArray array];
            for (NSXMLElement *el in queryChildren) {
                if (![el.name isEqualToString:@"instructions"]) {
                    if ([el.name isEqualToString:@"x"]) {
                        //table fields
                        NSArray *namespaces = [el namespaces];
                        for (NSXMLNode *node in namespaces) {
                            if ([node.stringValue isEqualToString:@"jabber:x:data"]) {
                                //this is right
                                NSArray *tableChildren = [el elementsForName:@"field"];
                                for (NSXMLElement *tel in tableChildren) {
                                    [tFields addObject:[XMPPSearchNode nodeWithElement:tel]];
                                }
                                break;
                            }
                        }
                    }else {
                        [nFields addObject:[XMPPSearchNode nodeWithElement:el]];
                    }
                }else {
                    _tableInstructions = [el stringValue];
                }
            }
            _singleFields = [nFields copy];
            _tableFields = [tFields copy];
        }
    }
    return self;
}

+ (id)resaultWithElement:(DDXMLElement *)element
{
    return [[self alloc] initWithElement:element];
}

- (NSArray *)copyForSingleFields
{
    NSMutableArray *fields = [NSMutableArray arrayWithCapacity:_singleFields.count];
    for (XMPPSearchNode *node in _singleFields) {
        [fields addObject:[node copy]];
    }
    return [fields copy];
}

- (NSArray *)copyForTableFields
{
    NSMutableArray *fields = [NSMutableArray arrayWithCapacity:_tableFields.count];
    for (XMPPSearchNode *node in _tableFields) {
        [fields addObject:[node copy]];
    }
    return [fields copy];
}

@end
