//
//  CompareLineChartDataSet.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/11/2.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

open class CompareLineChartDataSet: LineChartDataSet {
    //对比股票缩放比例
    @objc open var drawScale: Double = 1
    @objc open var indexValueMap = [Int: ChartDataEntry]()
    
    public override init(entries: [ChartDataEntry]?, label: String?) {
        super.init(entries: entries, label: label)
        entries?.forEach {
            indexValueMap[Int($0.x)] = $0
        }
    }

    @objc public convenience init(compareEntries: [CompareChartDataEntry]?, label: String?) {
        self.init(entries: compareEntries, label: label)
    }
    
    @objc public convenience init(compareEntries: [CompareChartDataEntry]?) {
        self.init(entries: compareEntries, label: "CompareChartDataSet")
    }
    
    public required init() {
        super.init()
    }
    
    open override func entryForIndex(_ i: Int) -> ChartDataEntry? {
        return indexValueMap[i]
    }
    
    
    @objc override open func calcMinMaxY(entry e: ChartDataEntry)
    {
        //处理缩放比例计算
        let tempY = e.y * drawScale
        if tempY < _yMin
        {
            _yMin = tempY
        }
        if tempY > _yMax
        {
            _yMax = tempY
        }
    }
    
    open override func copy(with zone: NSZone? = nil) -> Any
    {
        let copy = super.copy(with: zone) as! CompareLineChartDataSet
        copy.drawScale = drawScale
        copy.indexValueMap = indexValueMap
        return copy
    }
}
