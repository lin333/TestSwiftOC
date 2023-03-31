//
//  ICustomChartDataSetMove.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/27.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit
import CoreGraphics
/// 移动
public protocol ICustomChartDataSetMove {
    
    /// 整体移动dataset
    /// - Parameters:
    ///   - x: x description
    ///   - y: y description
    func totalGraphicstMoveBy(with translation: CGPoint)
    
    /// 移动单一的entry
    /// - Parameters:
    ///   - x: x description
    ///   - y: y description
    func singleEntryMoveBy(editEntry: CustomChartDataEntry?, translation: CGPoint)
    
    
    /// 添加闭合区域路径
    /// - Parameter entries: 形成区域的点
    func appendClosedGraphicsPathLocation(entries: [ChartDataEntry])
    
    /// 添加单个线通道
    /// - Parameters:
    ///   - entries: 形成区域的点
    ///   - maxDiffValue: maxDiffValue description
    func appendSinglePathLocation(points: [CGPoint], maxDiffValue: CGFloat)
    
    /// 删除路径信息
    func clearPathLocation()

}
