//
//  TBSwiftComponentService.h
//  Pods
//
//  Created by linbingjie on 2023/1/5.
//

#ifndef TBSwiftComponentService_h
#define TBSwiftComponentService_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBSwiftComponentService <NSObject>

/// 判断是否是red up
- (BOOL)swiftService_isMobileRedUP;

- (void)swiftService_setSymbolFont:(BOOL)symbolFront;

- (BOOL)swiftService_isSymbolFront;

- (void)swiftService_showFloatingPanelWithParentVC:(UIViewController *)parentVC
                                         contentVC:(UIViewController *)contentVC
                                         trackView:(UIScrollView *)trackView
                                     contentHeight:(CGFloat)contentHeight;
- (void)swiftService_showFloatingPanelWithParentVC:(UIViewController *)parentVC
                                         contentVC:(UIViewController *)contentVC
                                         trackView:(UIScrollView *)trackView
                                     contentHeight:(CGFloat)contentHeight
                                         backClear:(BOOL)backClear; // 背景透明，FloatingPanel默认为black

- (void)swiftService_showWithTitle:(NSString *)title
                           message:(NSString *)message
                      confirmTitle:(NSString *)confirmTitle
                       cancelTitle:(NSString *)cancelTitle
                  selectedCallback:(void(^)(NSInteger index))selectedCallback;

- (NSUInteger)swiftService_languageSelectedIndex;

- (void)swiftService_setLanguageSelectedIndex:(NSUInteger)selectedIndex;

- (NSArray *)swiftService_allLanguages;

- (NSString *)swiftService_currentLocalizableFolderName;

- (NSUInteger)swiftService_languageCurrentType;

- (NSString *)swiftService_languageLocalizedString:(NSString *)key bundle:(NSBundle *)bundle table:(NSString *)table withComment:(NSString *)comment;

- (NSString *)swiftService_languageLocalizedString:(NSString *)key withComment:(NSString *)comment;

- (BOOL)swiftService_languageIsTraditionalChinese;

- (BOOL)swiftService_languageIsSimpleChinese;

- (BOOL)swiftService_languageIsSysSimpleChinese;

- (NSString *)swiftService_currentLangParameter;

- (void)swiftService_fetchBFFConfigs:(BOOL)updateIndex;

@end

NS_ASSUME_NONNULL_END

#endif /* TBSwiftComponentService_h */
