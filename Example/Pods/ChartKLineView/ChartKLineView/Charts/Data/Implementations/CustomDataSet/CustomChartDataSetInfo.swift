//
//  CustomChartDataSetInfo.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/4/28.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

extension CustomChartDataSet: ICustomChartDataSetInfo {

    @objc open var customDrawColor: NSUIColor {
        return ChartColorTemplates.colorFromString(customDrawColorString)
    }
    
    @objc open var customDrawTranslateMap: [String: Any] {
        return ["points": entriesPointArray,
                "color": customDrawColorString,
                "width": lineWidth,
                "type": customDrawLineType.rawValue,
                "klineType": customDrawRelationKlineType.rawValue,
                "time": customDrawAddTimeStamp,
                "lineStyle": customDrawLineStyle.rawValue]
    }
    
    @objc open var remainPointCount: Int {
        return self.customDrawLineType.compeleteCount - count
    }
    
    @objc open var compeletedPointCount: Int {
        return  self.customDrawLineType.compeleteCount
    }
    
    private var entriesPointArray: [[String: Any]] {
        var array = [[String: Any]]()
        if let entries = entries as? [CustomChartDataEntry] {
            entries.filter { !$0.hidingEnable }.forEach {
                array.append(["timeStamp": $0.timestamp, "price": $0.y])
            }
        }
        
        return array
    }
    
    private struct CustomDrawTimeDistance {
        ///计算k线间距，已毫秒记
        static let minute   = 60.0 * 1000.0
        static let hour     = minute * 60.0
        static let day      = hour * 24.0
        static let week     = day * 7.0
        static let month    = day * 28
    }
    
    @objc open var displayKlineTypeTimeDistance: Double {
        switch self.customDrawDisplayKlineType {
        case .RealTime1Day, .RealTime5Day, .Candle1Minute, .Trend1Minute:
            return CustomDrawTimeDistance.minute
            
        case .Candle3Minute:
            return CustomDrawTimeDistance.minute * 3.0
        case .Candle5Minute:
            return CustomDrawTimeDistance.minute * 5.0
        case .Candle10Minute:
            return CustomDrawTimeDistance.minute * 10.0
        case .Candle15Minute:
            return CustomDrawTimeDistance.minute * 15.0
        case .Candle30Minute:
            return CustomDrawTimeDistance.minute * 30.0
        case .Candle45Minute:
            return CustomDrawTimeDistance.minute * 45.0
        case .Candle1Hour:
            return CustomDrawTimeDistance.hour
        case .Candle2Hour:
            return CustomDrawTimeDistance.hour * 2.0
        case .Candle3Hour:
            return CustomDrawTimeDistance.hour * 3.0
        case .Candle4Hour:
            return CustomDrawTimeDistance.hour * 4.0
        case .Candle6Hour:
            return CustomDrawTimeDistance.hour * 6.0
        case .Candle1Day:
            return CustomDrawTimeDistance.day
        case .Candle1Week:
            return CustomDrawTimeDistance.week
        case .Candle1Month:
            return CustomDrawTimeDistance.month
        case .Candle1Year:
            return CustomDrawTimeDistance.month * 12.0
        case .All:
            return CustomDrawTimeDistance.week
        case .PeriodOneMonthCandle1Hour:
            return CustomDrawTimeDistance.hour
        case .PeriodThreeMonthCandle1Day:
            return CustomDrawTimeDistance.day
        case .PeriodSixMonthCandle1Day:
            return CustomDrawTimeDistance.day
        case .PeriodThisYearCandle1Week:
            return CustomDrawTimeDistance.week
        case .PeriodOneYearCandle1Week:
            return CustomDrawTimeDistance.week
        case .PeriodFiveYearCandle1Month:
            return CustomDrawTimeDistance.month
        default:
            return CustomDrawTimeDistance.day
        }
    }
    
    ///线段标签：分时显示HH:MM,日K至月K展示MM-DD，月K以上展示YY-MM
    private struct CustomDrawDateFormat {
        ///计算k线间距，已毫秒记
        static let HM   = "HH:mm"
        static let MD   = "MM-dd"
        static let YM   = "yyyy-MM"
    }
    
    @objc open var displayKlineTypeDateFormat: String {
        switch self.customDrawDisplayKlineType {
            
        case .RealTime1Day, .RealTime5Day, .Trend1Minute: fallthrough
        case .Candle1Minute: fallthrough
        case .Candle3Minute: fallthrough
        case .Candle5Minute: fallthrough
        case .Candle10Minute: fallthrough
        case .Candle15Minute: fallthrough
        case .Candle30Minute: fallthrough
        case .Candle45Minute: fallthrough
        case .Candle1Hour: fallthrough
        case .Candle2Hour: fallthrough
        case .Candle3Hour: fallthrough
        case .Candle4Hour: fallthrough
        case .Candle6Hour:
            return CustomDrawDateFormat.HM
            
        case .Candle1Day: fallthrough
        case .Candle1Week: fallthrough
        case .Candle1Month: fallthrough
        case .All: fallthrough
        case .PeriodOneMonthCandle1Hour: fallthrough
        case .PeriodThreeMonthCandle1Day: fallthrough
        case .PeriodSixMonthCandle1Day: fallthrough
        case .PeriodFiveYearCandle1Month:
            return CustomDrawDateFormat.MD

        case .Candle1Year:
            return CustomDrawDateFormat.YM

        default:
            return CustomDrawDateFormat.MD
        }
    }
    
}
