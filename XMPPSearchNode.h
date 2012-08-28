//
//  XMPPSearchField.h
//  SOP2p
//
//  Created by zrz on 12-8-16.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPElement.h"

typedef enum _XMPPSearchNodeType {
    kXMPPSearchNodeTypeUnknown = 0,
    kXMPPSearchNodeTypeBool,
    kXMPPSearchNodeTypeStringSingle,
    kXMPPSearchNodeTypeListSingle,
    kXMPPSearchNodeTypeJidSingle,
    kXMPPSearchNodeTypeHidden
}XMPPSearchNodeType;

Class classWithTypeString(NSString *typeString);

#pragma mark - XMPPSearchNode

// A abstract class, Super class of all node classes.

@interface XMPPSearchNode : NSObject
<NSCopying>{
@protected
    id  _defaultValue;
}

@property (nonatomic, strong)   NSString    *name;
@property (nonatomic, readonly) id  defaultValue;
@property (nonatomic, strong)   id  value;

- (NSXMLElement *)xmlElment;

- (XMPPSearchNodeType)valueType;

//init
+ (id)nodeWithElement:(NSXMLElement *)element;

@end

#pragma mark - XMPPSearchSingleNode

//<name>word</name>
@interface XMPPSearchSingleNode : XMPPSearchNode

@end

#pragma mark - XMPPSearchFieldNode

//Super class of field classes.
//<field var="name" type="valueType" label="label">
//  <value>value</value>
//</field>
@interface XMPPSearchFieldNode : XMPPSearchNode

@property (nonatomic, readonly) NSString    *label;

- (NSXMLElement *)xmlFullElment:(BOOL)isFull;
- (id)initWithElement:(NSXMLElement *)element;

@end

#pragma mark - XMPPSearchBoolNode

@interface XMPPSearchBoolNode : XMPPSearchFieldNode

- (BOOL)boolValue;
- (void)setBoolValue:(BOOL)boolValue;

@end

#pragma mark - XMPPSearchStringSingleNode

@interface XMPPSearchStringSingleNode : XMPPSearchFieldNode

- (NSString *)contentValue;
- (void)setContentValue:(NSString*)contentValue;

@end

#pragma mark - XMPPSearchListSingleNode

@interface XMPPSearchListOption : NSObject

@property (nonatomic, strong)   NSString    *label,
                                            *value;

- (NSXMLElement *)xmlElment;

//init
+ (id)optionWithElement:(NSXMLElement *)element;
- (id)initWithElement:(NSXMLElement *)element;

@end

@interface XMPPSearchListSingleNode : XMPPSearchFieldNode

@property (nonatomic, readonly) NSArray     *options;

@property (nonatomic, assign)   NSUInteger  selected;

@end

#pragma mark - XMPPSearchHideNode

@interface XMPPSearchHideNode : XMPPSearchFieldNode

@end

#pragma mark - XMPPSearchJidSingleNode

@interface XMPPSearchJidSingleNode : XMPPSearchFieldNode

@end
