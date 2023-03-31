//
//  ChartEnum.swift
//  TBKLineChartView
//
//  Created by luopengfei on 2018/2/24.
//  Copyright © 2018年 luopengfei. All rights reserved.
//

import Foundation

/// MARK- 横竖屏模式
@objc(TBLandScapeMode)
public enum LandScapeMode: Int {
    case Portrait // 竖屏
    case LandScape // 横屏
}

/// 策略助手
@objc(TBStockStrategyType)
public enum StockStrategyType: Int {
    case None
    case ZigZag // 趋势图
}

/// MARK- 图表绘制市场类型
@objc(TBChartDrawMarketType)
public enum StockDrawType: Int {
    case Common             // 默认，通用，这种情况下使用server返回开收盘时间进行计算
    case US                 // 美
    case HK                 // 港
    case CN                 // A
    case Option             // 期权
    case OptionDefault      // 期权默认值，server不返还交易区间，使用默认值
    case PreMarket          // 盘前
    case SufMarket          // 盘后
    case Futures            // 期货
    case UK                 // 伦敦
    case AStockSufMarket    // A股盘后
    case SI                 // 新加坡
    case AU                 // 澳大利亚
    case NZ                 // 新西兰
    case DigitalCurrency    // 数字货币
    case USTotalMarket      //美股全天
    case Bond               //债券
    case Forex              //外汇
}

@objc(TBLineType)
public enum LineType: Int {
    case Trend1Minute
    case Candle1Minute
    case Candle3Minute
    case Candle5Minute
    case Candle10Minute
    case Candle15Minute
    case Candle30Minute
    case Candle45Minute
    case Candle1Hour
    case Candle2Hour
    case Candle3Hour
    case Candle4Hour
    case Candle6Hour
    case Candle1Day
    case Candle1Week
    case Candle1Month
    case Candle1Year
    case All
    
    case RealTime1Day
    case RealTime5Day
    
      // Period
    case PeriodOneMonthCandle1Hour
    case PeriodThreeMonthCandle1Day
    case PeriodSixMonthCandle1Day
    case PeriodThisYearCandle1Week
    case PeriodOneYearCandle1Week
    case PeriodFiveYearCandle1Month
    
    case Candle2Minute
    case Candle1Quarter

}

@objc(TBKLineChartYAxisType)
public enum YAxisType: Int {
    case MA
    case BOLL
    case EMA
    case SAR
    case TCTI
    case BBI
    case HMA
    case LMA
    case VMA
    case BBIBOLL
    case ALLIGAT
    case PBX
    case ENE
    case MIKE
    case XT
    case JAX
    
    case VOLUME
    case MACD
    case KDJ
    case RSI
    case ARBR
    case OBV
    case DMI
    case WR
    case EMV
    case DMA
    case CCI
    case MFI
    
    case LINE
    
    case COMPARE /// add:叠加比较type，用了处理叠加
    case ATR
    case TRIX
    case OIV
    case VR
    case TPXH
    case MACDKDJ
    
    case BIAS
    case DKX
    case PCNT
    case ROC
    case SKDJ
    case UDL
    case VRSI
    case WAD
    case XS
    case IV
    case OPENINT
    
    case None
    
    case ZigZag
    case MTM
    case ADTM
    case CR
    case WVAD
    
    case UnChecked
}

@objc(TCTILengendShape)
public enum TCTIShape: Int
{
    case square
    case circle
    case triangle
    case none
}
