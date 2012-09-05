//
//  XMPPSearchModule.h
//  SOP2p
//
//  Created by zrz on 12-8-7.
//  Copyright (c) 2012年 Sctab. All rights reserved.
//

#import "XMPPModule.h"
#import "XMPPSearchReported.h"
#import "XMPPSearchResult.h"

@class XMPPIQ;

@interface XMPPSearchModule : XMPPModule {
    NSMutableDictionary *_searchUserDatas;
}

@property (nonatomic, strong)   NSString    *searchHost;
// Get the template, using it after invoke -askForFields and
// -searchModelGetFields be invoked.
@property (nonatomic, readonly) XMPPSearchResult   *result;

/*
    Request for searching.
    @params fields 
        fields is NSArray of XMPPSearchNode. get from
        -[XMPPSearchResault copyForSingleFields] or
        -[XMPPSearchResault copyForTableFields]. And can 
        make the NSArray yourself, too.
    @params userData
        The params will be the third params in
        -searchModel:result:userData:
 */
 
- (void)searchWithFields:(NSArray*)fields
                userData:(id)userData;

//Request for template from server, -searchModelGetFields
//will be invoked when server response this request.
- (void)askForFields;

@end

@protocol XMPPSearchModuleDelegate <NSObject>

- (void)searchModel:(XMPPSearchModule*)searchModul result:(XMPPSearchReported*)result userData:(id)userData;
- (void)searchModelGetFields:(XMPPSearchModule *)searchModul;

@end