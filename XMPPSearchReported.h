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

/**
 * @property reporteds is array of XMPPSearchNode
 * <reported>
 *  <field var='first' label='Given Name' type='text-single'/>
 * </reported>
 * @property items is array of NSDictionary, var is the key.
 * <item>
 *  <field var='first'><value>Benvolio</value></field>
 *  <field var='last'><value>Montague</value></field>
 * </item>
 */

@property (nonatomic, strong)   NSArray *reporteds, 
                                        *items;    

+ (id)reportWithElement:(NSXMLElement *)element;
- (NSXMLElement *)xmlElement;

@end
