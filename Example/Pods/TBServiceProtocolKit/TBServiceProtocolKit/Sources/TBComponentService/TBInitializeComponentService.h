//
//  TBInitializeComponentService.h
//  Pods
//
//  Created by linbingjie on 2022/6/7.
//

#ifndef TBInitializeComponentService_h
#define TBInitializeComponentService_h

NS_ASSUME_NONNULL_BEGIN

@protocol TBInitializeComponentService <NSObject>

- (void)tbInitialize_loadTabBar;

- (void)tbInitialize_reloadTradeTab;

- (void)tbInitialize_hideNewbieGiftGuide:(id)tabBarController;

@end

NS_ASSUME_NONNULL_END

#endif /* TBInitializeComponentService_h */
