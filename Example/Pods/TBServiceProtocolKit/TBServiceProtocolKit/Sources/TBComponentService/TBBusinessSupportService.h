//
//  TBBusinessSupportService.h
//  TBServiceProtocolKit
//
//  Created by linbingjie on 2023/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TBBusinessSupportService <NSObject>

- (NSString *)tbBusinessSupport_formatVolumeCount:(long long )volume;

// format 时间， 传入market确定是美东还是北京时间
- (NSString *)tbBusinessSupport_longToDateFormat:(long long)time
                                          format:(NSString *)formaterString
                                          market:(NSString *)market;

- (NSTimeZone *)tbBusinessSupport_timeZoneForMarket:(NSString *)market;

- (BOOL)tbBusinessSupport_isAllowAudioNotification;

- (NSDateFormatter *)tbBusinessSupport_shareCNDateFormatter;

// format 时间, 中国区时间.
- (NSString *)tbBusinessSupport_longToNSDateCNFormat:(long long)time
                                              format:(NSString *)formaterString;

- (BOOL)tbBusinessSupport_fetchDevSensorsEnableLogger;

- (void)tbBusinessSupport_setDevSensorsEnableLogger:(BOOL)enableLog;
@end

NS_ASSUME_NONNULL_END
