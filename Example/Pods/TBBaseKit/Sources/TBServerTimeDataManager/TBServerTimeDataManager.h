//
//  TBServerTimeDataManager.h
//  Stock
//
//  Created by liwt on 11/30/15.
//  Copyright © 2015 com.tigerbrokers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBBaseUtility.h"

@interface TBServerTimeDataManager : NSObject

DECLARE_SHARED_INSTANCE(TBServerTimeDataManager);

@property (atomic, strong) NSNumber *serverTime;

@end
