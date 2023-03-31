//
//  ICustomChartDataSet.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/20.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

///自定义绘制的类型
@objc public enum CustomDrawLineType: Int {
    case lineStraight = 0
    case lineSegment
    case rectangle
    case lineVertical
    case lineHorizontal
    case lineRgression
    case lineFibonacciPeriod
    case lineRangeStatistic
}

/// 计算触摸点位置的区域类型
public enum CustomCalculatePathType {
    case singleLine
    case extendLine
    case multiLine
    case closed
}

/// 绘线的设置格式
@objc public enum CustomDrawLineStyle: Int {
    case lineSolid = 0
    case lineSolidArrow
    case lineSolidLeftArrow
    case lineSolidRightArrow
    
    case lineDotted
    case lineDottedArrow
    case lineDottedLeftArrow
    case lineDottedRightArrow
}

public enum CustomDrawArrowStyle {
    case left
    case right
    case both
    case none
}

extension CustomDrawLineType {
    ///绘制类型的计算类型，用于区域点击计算
    var calculatePathType: CustomCalculatePathType {
        switch self {
           
        case .lineSegment:
            return .singleLine
            
        case .lineStraight, .lineVertical, .lineHorizontal:
            return .extendLine
            
        case .rectangle:
            return .closed
            
        case .lineRgression, .lineFibonacciPeriod, .lineRangeStatistic:
            return .multiLine
        }
    }

    ///完整绘图需要的点的数量
    var compeleteCount: Int {
        switch self {
        case .lineSegment, .lineStraight:
            return 2
        case .rectangle:
            return 2
        case .lineVertical, .lineHorizontal:
            return 1
        case .lineRgression:
            return 3
        case .lineFibonacciPeriod, .lineRangeStatistic:
            return 2
            
        default:
            return 2
        }
    }
    ///是否需要补充绘制点，例如矩形完成绘制需要两个点，但是绘制需要4个，补充两个
    var needSupplyGraphicsPoint: Bool {
        switch self {
        case .lineSegment, .lineStraight, .lineVertical, .lineRgression, .lineFibonacciPeriod, .lineHorizontal, .lineRangeStatistic:
            return false
        case .rectangle:
            return true
        default:
            return false
        }
    }
}


extension CustomDrawLineStyle {
    
    /// 是否需要虚线
    var lineDashed: Bool {
        switch self {
        case .lineDotted, .lineDottedArrow, .lineDottedLeftArrow, .lineDottedRightArrow:
            return true
        default:
            return false
        }
    }
    
    /// 箭头的样式
    var lineArrowStyle: CustomDrawArrowStyle {
        switch self {
        case .lineDottedArrow, .lineSolidArrow:
            return .both
        case .lineDottedRightArrow, .lineSolidRightArrow:
            return .right
        case .lineDottedLeftArrow, .lineSolidLeftArrow:
            return .left
        default:
            return .none
        }
    }
}

public protocol ICustomChartDataSet: ILineChartDataSet, ICustomChartDataSetDraw, ICustomChartDataSetLocation, ICustomChartDataSetMove, ICustomChartDataSetInfo {
    /// 绘制图形的类型
    var customDrawLineType: CustomDrawLineType { get set }
    /// 绘图的样式
    var customDrawLineStyle: CustomDrawLineStyle { get set }
    /// 绘图产生的路径
    var customDrawLinePaths: [UIBezierPath] { get set }
    /// 当前视图是否选中状态
    var customDrawSelected: Bool { get set }
    /// 是否开启磁吸
    var customDrawMagnetEnable: Bool { get set }
    /// 绘图数据关联的k线类型
    var customDrawRelationKlineType: LineType { get set }
    /// 数据第一次添加的时间
    var customDrawAddTimeStamp: Double { get set }
    /// 绘图数据展示的k线周期
    var customDrawDisplayKlineType: LineType { get set }
    /// 需要展示的时间时区
    var customDrawDisplayTimeZoneID: String? { get set }
}
