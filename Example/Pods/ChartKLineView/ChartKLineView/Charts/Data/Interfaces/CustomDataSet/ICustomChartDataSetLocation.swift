//
//  ICustomChartDataSetLocation.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/27.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

/// 计算区间
public protocol ICustomChartDataSetLocation {
    
    /// 通过触摸点
    /// - Parameters:
    ///   - touchPoint: 触摸点
    ///   - maxDiffValue: y轴的极值差，用来优化取点的范围
    func getEntryBy(touchPoint: CGPoint, maxXDiffValue: CGFloat, maxYDiffValue: CGFloat) -> CustomChartDataEntry?
    
    /// 计算触摸点是否在图形内部
    /// - Parameters:
    ///   - Point: 触摸点
    ///   - maxDiffValue: y轴绘制极差
    func calculatePositionInGraphicsBy(touchPoint: CGPoint) -> Bool
}
