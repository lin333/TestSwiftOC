//
//  CompareChartDataEntry.swift
//  TBCharts
//
//  Created by JustLee on 2020/12/4.
//

import UIKit

open class CompareChartDataEntry: ChartDataEntry {
    /// 用于对比价格计算的y值，一般为当天的开盘价、分时为前一天的收盘价
    @objc open var compareY: Double = 0

    @objc public init(x: Double, y: Double, compareY: Double) {
        super.init(x: x, y: y)
        self.compareY = compareY
    }
    
    override init(x: Double, y: Double) {
        super.init(x: x, y: y)
        self.compareY = y
    }
    
    public required init() {
        super.init()
    }
    
}
