//
//  ICustomChartDataSetDraw.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/27.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit
import CoreGraphics

/// 绘图
public protocol ICustomChartDataSetDraw { 
    /// 增加一个新的绘制点
    /// - Parameter entry: entry description
    func addCustomEntry(entry: CustomChartDataEntry?)
    
    ///判断当前dataset的编辑状态，例如直线需要两个点，如果当前已经传入一个点，则证明已经编辑未完成
    func completeCurrentCustomDrawing() -> Bool
    
    ///图形绘制，需要在基本点的基础上补充剩余的点
    func supplyGraphicsPoints()
    
    ///多点固定规则图形，移动一个点需要校正其他点的位置
    func correctOtherPointsBy(entry: CustomChartDataEntry?)
    
    /// 计算磁吸
    /// - Parameters:
    ///   - entry: entry description
    ///   - changeValueDiff: y轴方向的移动值
    func calculateMagnetEntry(entry: CustomChartDataEntry?, changeValueDiff: Double)
    
    /// 生成展示数据
    /// - Parameters:
    ///   - xRange: x轴坐标
    ///   - yRange: y轴坐标
    func generateDisplayEntries(xRange: Range, yRange: Range)
}
