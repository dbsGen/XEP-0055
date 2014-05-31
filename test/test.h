//
//  test.h
//  test
//
//  Created by zrz on 12-9-9.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPSearchModule.h"

@interface test : NSObject {
    XMPPStream  *_stream;
    XMPPSearchModule    *_searchModule;
}

- (void)connect;
- (void)askForFields;
- (void)search;

@end
