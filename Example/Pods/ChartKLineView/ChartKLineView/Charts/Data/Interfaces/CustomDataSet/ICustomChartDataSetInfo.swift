//
//  ICustomChartDataSetInfo.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/4/28.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

/// 绘图
public protocol ICustomChartDataSetInfo {
    
    /// 需要展示的颜色
    var customDrawColor: NSUIColor { get }
    
    /// 存储信息所需要的参数
    var customDrawTranslateMap: [String: Any] { get }
    
    /// 画线剩余的点数
    var remainPointCount: Int { get }
    
    /// 完成所需的点数
    var compeletedPointCount: Int { get }
    
    /// k线类型画图的间隔时间
    var displayKlineTypeTimeDistance: Double { get }
    
    /// 绘线当前的k线展示类型
    var displayKlineTypeDateFormat: String { get }
}
