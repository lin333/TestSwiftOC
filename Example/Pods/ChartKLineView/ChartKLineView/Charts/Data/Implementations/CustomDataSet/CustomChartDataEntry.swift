//
//  CustomChartDataEntry.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/24.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

open class CustomChartDataEntry: ChartDataEntry {
    
    ///是否需要在绘制的时候隐藏这个点，比如射线的延长点
    @objc open var hidingEnable: Bool = false
    
    /// 当前绑定的candleEntry
    public var combinedEntry: ChartDataEntry?

    @objc public required init()
    {
        super.init()
    }
    
    @objc public override init(x: Double, y: Double)
    {
        super.init(x: x, y: y)
    }
    
    @objc public init(hidingEntry x: Double, y: Double)
    {
        super.init(x: x, y: y)
        hidingEnable = true
    }
    
    @objc public init(data: [String: Any]) {
        super.init()
        
        guard let data = data as? [String: Double] else {
            return
        }
        
        self.y = data["price"] ?? 0
        self.timestamp = data["timeStamp"] ?? -1
    }
    
    override open func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! CustomChartDataEntry
        copy.hidingEnable = hidingEnable
        copy.timestamp = timestamp
        return copy
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? CustomChartDataEntry else { return false }

        if self === object
        {
            return true
        }

        return y == object.y
            && timestamp == object.timestamp
    }

}
