//
//  XMPPSearchReported.m
//  SOP2p
//
//  Created by zrz on 12-8-19.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import "XMPPSearchReported.h"

@implementation XMPPSearchReported

+ (id)reportWithElement:(NSXMLElement *)element
{
    XMPPSearchReported *report = [[self alloc] init];
    NSXMLElement *query = [[element elementsForName:@"query"] lastObject];
    NSXMLElement *x = [[query elementsForName:@"x"] lastObject];
    
    NSArray *singleItems = [query elementsForName:@"item"];
    if (x) {
        NSXMLElement *reported = [[x elementsForName:@"reported"] lastObject];
        NSArray *reportFields = [reported elementsForName:@"field"];
        
        NSMutableArray *mReports = [NSMutableArray arrayWithCapacity:reportFields.count];
        for (NSXMLElement *reportField in reportFields) {
            [mReports addObject:[XMPPSearchNode nodeWithElement:reportField]];
        }
        report.reporteds = [mReports copy];
        
        NSArray *items = [x elementsForName:@"item"];
        
        NSMutableArray *mItems = [NSMutableArray arrayWithCapacity:items.count];
        for (NSXMLElement *itemXml in items) {
            NSArray *fields = [itemXml elementsForName:@"field"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:fields.count];
            for (NSXMLElement *fieldInItem in fields) {
                
                NSString *name = [[fieldInItem attributeForName:@"var"] stringValue];
                NSString *value = [[[fieldInItem elementsForName:@"value"] lastObject] stringValue];
                if (name && value) {
                    [dic setObject:value
                            forKey:name];
                }
            }
            [mItems addObject:[dic copy]];
        }
        report.items = [mItems copy];
    }else if (singleItems.count > 0) {
        __block NSMutableArray *mItems = [NSMutableArray arrayWithCapacity:singleItems.count];
        [singleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSXMLElement *e = obj;
            NSArray* children = [e children];
            __block NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:children.count + 1];
            [dic setObject:@"jid" forKey:[[e attributeForName:@"jid"] stringValue]];
            [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [dic setObject:[obj name] forKey:[obj stringValue]];
            }];
            [mItems addObject:dic];
        }];
        report.items = [mItems copy];
    }

    return report;
}

- (NSXMLElement *)xmlElement
{
    // not finished, this method will be used in the server part.
    return nil;
}

@end
