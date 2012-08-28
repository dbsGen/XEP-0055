//
//  XMPPSearchField.m
//  SOP2p
//
//  Created by zrz on 12-8-16.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import "XMPPSearchNode.h"
#import <objc/runtime.h>

#pragma mark - inline

NS_INLINE NSString *stringForType(XMPPSearchNodeType type)
{
    switch (type) {
        case kXMPPSearchNodeTypeBool:
            return @"boolean";
        case kXMPPSearchNodeTypeHidden:
            return @"hidden";
        case kXMPPSearchNodeTypeListSingle:
            return @"list-single";
        case kXMPPSearchNodeTypeStringSingle:
            return @"text-single";
        case kXMPPSearchNodeTypeJidSingle:
            return @"jid-single";
            
        default:
            return nil;
    }
}

Class classWithTypeString(NSString *typeString)
{
    if ([typeString isEqualToString:@"boolean"]) {
        return [XMPPSearchBoolNode class];
    }else if ([typeString isEqualToString:@"hidden"]) {
        return [XMPPSearchHideNode class];
    }else if ([typeString isEqualToString:@"list-single"]) {
        return [XMPPSearchListSingleNode class];
    }else if ([typeString isEqualToString:@"text-single"]) {
        return [XMPPSearchStringSingleNode class];
    }else if ([typeString isEqualToString:@"jid-single"]) {
        return [XMPPSearchJidSingleNode class];
    }
    return nil;
}

#pragma mark - XMPPSearchNode

@implementation XMPPSearchNode

+ (id)nodeWithElement:(NSXMLElement *)element
{
    if ([element.name isEqualToString:@"field"]) {
        return [XMPPSearchFieldNode nodeWithElement:element];
    }else {
        return [XMPPSearchSingleNode nodeWithElement:element];
    }
}

- (XMPPSearchNodeType)valueType{
    return kXMPPSearchNodeTypeUnknown;
}

- (NSXMLElement *)xmlElment
{
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    XMPPSearchNode *node = [[[self class] allocWithZone:zone] init];
    node.name = self.name;
    node->_defaultValue = self.defaultValue;
    node.value = self.value;
    return node;
}

@end

#pragma mark - XMPPSearchSingleNode

@implementation XMPPSearchSingleNode

+ (id)nodeWithElement:(NSXMLElement *)element
{
    XMPPSearchSingleNode *node = [[XMPPSearchSingleNode alloc] init];
    node.name = element.name;
    return node;
}

- (XMPPSearchNodeType)valueType
{
    return kXMPPSearchNodeTypeStringSingle;
}

- (NSXMLElement *)xmlElment
{
    if (!self.name) {
        DDLogError(@"Node name is nil.");
        return nil;
    }
    if (self.value) {
        return [NSXMLElement elementWithName:self.name
                                 stringValue:self.value];
    }else {
        return [NSXMLElement elementWithName:self.name];
    }
}

@end

#pragma mark - XMPPSearchFieldNode

@implementation XMPPSearchFieldNode

@synthesize label = _label;

- (id)initWithElement:(NSXMLElement *)element
{
    self = [super init];
    if (self) {
        self.name = [[element attributeForName:@"var"] stringValue];
        self->_label = [[element attributeForName:@"label"] stringValue];
    }
    return self;
}

+ (id)nodeWithElement:(NSXMLElement *)element
{
    NSString *type = [[element attributeForName:@"type"] stringValue];
    Class class = classWithTypeString(type);
    return [[class alloc] initWithElement:element];
}

- (NSXMLElement *)xmlElment
{
    id value = self.value;
    if (!value) {
        value = self.defaultValue;
    }
    if (!value || !self.name) {
        DDLogWarn(@"Xml format error, value or var is nil");
        return nil;
    }

    NSXMLElement *element = [NSXMLElement elementWithName:@"field"
                                                 children:@[[NSXMLElement elementWithName:@"value"
                                                                              stringValue:[value description]]]
                                               attributes:@[[NSXMLNode attributeWithName:@"var"
                                                                             stringValue:self.name]]];
    return element;
}

- (NSXMLElement *)xmlFullElment:(BOOL)isFull
{
    NSXMLElement *element = [self xmlElment];
    if (isFull) {
        NSString *type = stringForType([self valueType]);
        if (type) 
            [element addAttribute:[NSXMLNode attributeWithName:@"type"
                                                   stringValue:type]];
        if (self.label) {
            [element addAttribute:[NSXMLNode attributeWithName:@"label"
                                                   stringValue:self.label]];
        }
    }
    return element;
}

- (id)copyWithZone:(NSZone *)zone
{
    XMPPSearchFieldNode *field = [super copyWithZone:zone];
    field->_label = self.label;
    return field;
}

@end

#pragma mark - XMPPSearchBoolNode

@implementation XMPPSearchBoolNode

- (id)initWithElement:(NSXMLElement *)element
{
    self = [super initWithElement:element];
    if (self) {
        NSString *content = [[[element elementsForName:@"value"] lastObject] stringValue];
        if ([content length]) {
            self->_defaultValue = [NSNumber numberWithBool:[content boolValue]];
        }
    }
    return self;
}

- (XMPPSearchNodeType)valueType
{
    return kXMPPSearchNodeTypeBool;
}

- (BOOL)boolValue
{
    return [self.value boolValue];
}

- (void)setBoolValue:(BOOL)boolValue
{
    self.value = [NSNumber numberWithBool:boolValue];
}

@end

#pragma mark - XMPPSearchStringSingleNode

@implementation XMPPSearchStringSingleNode

- (id)initWithElement:(NSXMLElement *)element
{
    
    self = [super initWithElement:element];
    if (self) {
        NSString *content = [[[element elementsForName:@"value"] lastObject] stringValue];
        if ([content length]) {
            self->_defaultValue = content;
        }
    }
    return self;
}

- (XMPPSearchNodeType)valueType
{
    return kXMPPSearchNodeTypeStringSingle;
}

- (NSString *)contentValue
{
    return self.value;
}

- (void)setContentValue:(NSString*)contentValue
{
    self.value = contentValue;
}

@end

#pragma mark - XMPPSearchListSingleNode

@implementation XMPPSearchListOption

- (NSXMLElement *)xmlElment
{
    if (!self.value || !self.label) {
        DDLogError(@"List option had not setted value or label");
        return nil;
    }
    NSXMLElement *element = [NSXMLElement elementWithName:@"option"
                                                 children:@[[NSXMLElement elementWithName:@"value"
                                                                              stringValue:self.value]]
                                               attributes:@[[NSXMLNode attributeWithName:@"label"
                                                                             stringValue:self.label]]];
    return element;
}

- (id)initWithElement:(NSXMLElement *)element
{
    self = [super init];
    if (self) {
        NSXMLElement *value = [[element elementsForName:@"value"] lastObject];
        self.value = value.stringValue;
        NSXMLNode *label = [element attributeForName:@"label"];
        self.label = label.stringValue;
    }
    return self;
}

+ (id)optionWithElement:(NSXMLElement *)element
{
    return [[XMPPSearchListOption alloc] initWithElement:element];
}

@end

@implementation XMPPSearchListSingleNode

@synthesize options = _options, selected = _selected;


- (id)initWithElement:(NSXMLElement *)element
{
    self = [super initWithElement:element];
    if (self) {
        NSString *content = [[[element elementsForName:@"value"] lastObject] stringValue];
        if ([content length]) {
            self->_defaultValue = content;
        }
        
        NSMutableArray *options = [NSMutableArray array];
        NSArray *optionElements = [element elementsForName:@"option"];
        
        for (NSXMLElement *optionElement in optionElements) {
            [options addObject:[XMPPSearchListOption optionWithElement:optionElement]];
        }
        self->_options = [options copy];
    }
    return self;
}

- (void)setSelected:(NSUInteger)selected
{
    if (selected >= _options.count) {
        selected = _options.count - 1;
    }
    _selected = selected;
    self.value = [(XMPPSearchListOption*)[_options objectAtIndex:selected] value];
}

- (XMPPSearchNodeType)valueType
{
    return kXMPPSearchNodeTypeListSingle;
}

@end

@implementation XMPPSearchHideNode

- (XMPPSearchNodeType)valueType
{
    return kXMPPSearchNodeTypeHidden;
}

@end

@implementation XMPPSearchJidSingleNode

- (XMPPSearchNodeType)valueType
{
    return kXMPPSearchNodeTypeJidSingle;
}

@end

