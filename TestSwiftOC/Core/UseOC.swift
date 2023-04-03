//
//  UseOC.swift
//  TestSwiftOC
//
//  Created by linbingjie on 2022/11/1.
//

import Foundation
import ChartKLineView

public class UseOC {
    public init() {
        
    }
    
    public func useOC() {
        LBJOC.loglog2()
        
    }
}

@objc(TBCommonChartYAxis)
open class TBCommonChartYAxis : YAxis {

    //边框线是否包含y坐标轴
    @objc open var bigGrideBorder: Bool = false
    // 是否需要将大数进行万、千万等格式化，使用TBUtils.formatVolumeCount方法格式化
    @objc open var shouldLocalFormat: Bool = false

    @objc open var customYAxisEntried: Bool = false

    // 最大值、最小值是否需要对齐图表顶部和底部
    @objc open var shouldAlignTop: Bool = false
    @objc open var shouldAlignBottom: Bool = false


    /// 最长Y轴值，当两个图表共用一个X轴时，需要统一Y轴边距时可以赋给最大值
    @objc open var longestText: String = ""


//    // MARK: - 下面逻辑是修复两个点（value）相同时，没有画出横线的问题
//    open override func calculate(min dataMin: Double, max dataMax: Double)
//    {
//        // if custom, use value as is, else use data value
//        var min = isAxisMinCustom ? _axisMinimum : dataMin
//        var max = isAxisMaxCustom ? _axisMaximum : dataMax
//
//        // Make sure max is greater than min
//        // Discussion: https://github.com/danielgindi/Charts/pull/3650#discussion_r221409991
//        if min > max
//        {
//            switch(isAxisMaxCustom, isAxisMinCustom)
//            {
//            case(true, true):
//                (min, max) = (max, min)
//            case(true, false):
//                min = max < 0 ? max * 1.5 : max * 0.5
//            case(false, true):
//                max = min < 0 ? min * 0.5 : min * 1.5
//            case(false, false):
//                break
//            }
//        }
//
//        // temporary range (before calculations)
//        let range = abs(max - min)
//
//        // in case all values are equal
//        if range <= exp(-11)
//        {
//            max = max * (1.0 + sameMinMaxMultiplier(max))
//            min = min * (1.0 - sameMinMaxMultiplier(min))
//            //添加一个极值为0的判断
//            if max == min && max == 0 {
//                max = 1
//                min = -1
//            }
//        }
//
//        // bottom-space only effects non-custom min
//        if !isAxisMinCustom
//        {
//            let bottomSpace = range * Double(spaceBottom)
//            _axisMinimum = (min - bottomSpace)
//        }
//
//        // top-space only effects non-custom max
//        if !isAxisMaxCustom
//        {
//            let topSpace = range * Double(spaceTop)
//            _axisMaximum = (max + topSpace)
//        }
//
//        validYChartMinMax()
//
//        // calc actual range
//        axisRange = abs(_axisMaximum - _axisMinimum)
//    }
//
//    private func validYChartMinMax() {
//        var min = _axisMinimum
//        var max = _axisMaximum
//
//        if min.isNaN || max.isNaN || min.isInfinite || max.isInfinite {
//            min = 0
//            max = 0.1
//        } else if (min == max) {
//            var delta = 0.0
//            if max == 0  {
//                delta = 0.1
//            } else {
//                delta = max * 0.1
//            }
//
//            max += delta/2.0
//            min -= delta/2.0
//        } else if (min > max) {
//            let avg = min/2.0 + max/2.0
//            let delta = fabs(max/2 - min/2)
//            max = avg + delta
//            min = avg - delta
//        }
//        _axisMaximum = max
//        _axisMinimum = min
//    }
//
//    //如果图表只有一个值会出现最大值最小值相同，造成坐标展示问题
//    //以10的三次方为阶段，分别为5 15 20
//    private func sameMinMaxMultiplier(_ value: Double) -> Double {
//        if value == 0 {
//            return 0
//        }
//        let level = fabs(log10(fabs(value))) / 3
//        return 0.05 * level
//    }

}
