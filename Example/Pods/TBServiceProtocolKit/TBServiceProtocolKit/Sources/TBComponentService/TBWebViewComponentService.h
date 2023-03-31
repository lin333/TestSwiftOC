//
//  TBWebViewComponentService.h
//  TBServiceProtocolKit
//
//  Created by chenxin on 2022/6/20.
//

#ifndef TBWebViewComponentService_h
#define TBWebViewComponentService_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBWebViewComponentService <NSObject>

- (NSString *)tbWeb_urlForWebPage:(UIViewController *)webViewController;

- (NSString *)tbWeb_inviteCodeFromWeb;

- (BOOL)tbWeb_shouldJumptoNative:(NSString *)linkUrl;
@end

NS_ASSUME_NONNULL_END

#endif /* TBWebViewComponentService_h */
