//
//  CustomChartDataSet.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/23.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

open class CustomChartDataSet: LineChartDataSet, ICustomChartDataSet {
    
    /// 当前设置的绘制类型
    @objc open var customDrawLineType: CustomDrawLineType = .lineSegment
    
    /// 当前设置的绘制样式
    @objc open var customDrawLineStyle: CustomDrawLineStyle = .lineSolid
    
    /// 当前设置的绘制颜色
    @objc open var customDrawColorString: String = "#000000"    

    /// 默认不选中
    @objc open var customDrawSelected: Bool = false
    
    /// 是否需要磁吸
    @objc open var customDrawMagnetEnable: Bool = true

    /// 计算路径的贝塞尔曲线
    @objc open var customDrawLinePaths: [UIBezierPath] = [UIBezierPath]()
    
    /// 绘制基于的k线展示类型
    @objc open var customDrawRelationKlineType: LineType = .Candle1Day
    
    /// 绘线当前的k线展示类型
    @objc open var customDrawDisplayKlineType: LineType = .Candle1Day
    
    /// 默认时间戳为0
    @objc open var customDrawAddTimeStamp: Double = 0.0
    
    ///默认无时区，只有期货有
    @objc open var customDrawDisplayTimeZoneID: String?
    
    public required init()
    {
        super.init()
    }
    
    public override init(entries: [ChartDataEntry]?, label: String?)
    {
        super.init(entries: entries, label: label)
    }
    
    @objc public convenience init(drawLineType: CustomDrawLineType, entries: [CustomChartDataEntry]?) {
        self.init(entries: entries, label: "CustomChartDataSet")

        customDrawLineType = drawLineType
    }
    
    @objc public init(data: [String: Any]) {
        super.init()
        
        if let width = data["width"] as? Double {
            lineWidth = CGFloat(width)
        }
        
        if let color = data["color"] as? String {
            customDrawColorString = color
        }
        
        if let value = data["type"] as? Int,
            let type = CustomDrawLineType(rawValue: value) {
            customDrawLineType = type
        }
        
        if let points = data["points"] as? [[String: Any]] {
            points.forEach {
                self.addCustomEntry(entry: CustomChartDataEntry(data: $0))
            }
        }
        
        if let value = data["klineType"] as? Int,
            let klineType = LineType(rawValue: value) {
            customDrawRelationKlineType = klineType
        }
        
        if let time = data["time"] as? Double {
            customDrawAddTimeStamp = time
        }
        
        if let lineStyle = data["lineStyle"] as? Int,
            let style = CustomDrawLineStyle(rawValue: lineStyle) {
            customDrawLineStyle = style
        }
        
    }
    
    /// 设置默认格式的虚线样式
    open override var lineDashLengths: [CGFloat]? {
        get {
            if customDrawLineStyle.lineDashed {
                return [5, 5]
            }
            return []
        }
        set {}
    }
    
    open override var circleHoleRadius: CGFloat {
        get {
            return 2.0
        }
        set {}
    }
    
    open override var circleRadius: CGFloat {
        get {
            return 12.0
        }
        set {}
    }
    
    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CustomChartDataSet
        copy.customDrawLineType = customDrawLineType
        copy.customDrawLineStyle = customDrawLineStyle
        copy.customDrawColorString = customDrawColorString
        copy.customDrawLinePaths = customDrawLinePaths
        copy.customDrawMagnetEnable = customDrawMagnetEnable
        copy.customDrawSelected = customDrawSelected
        copy.customDrawRelationKlineType = customDrawRelationKlineType
        return copy
    }
}
