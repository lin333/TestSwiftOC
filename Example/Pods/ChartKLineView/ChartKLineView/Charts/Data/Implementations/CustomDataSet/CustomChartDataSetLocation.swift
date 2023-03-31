//
//  CustomChartDataSetLocation.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/27.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit
import CoreGraphics

extension CustomChartDataSet: ICustomChartDataSetLocation {

    public func getEntryBy(touchPoint: CGPoint, maxXDiffValue: CGFloat, maxYDiffValue: CGFloat) -> CustomChartDataEntry? {
        for closestEntry in entries {
            ///默认范围为x轴方向2个坐标偏差，y轴方向绘制差值30%的偏差
            if fabs(closestEntry.x - Double(touchPoint.x)) < Double(maxXDiffValue) * 0.1 && fabs(closestEntry.y - Double(touchPoint.y)) < Double(maxYDiffValue) * 0.1 {
                return closestEntry as? CustomChartDataEntry
            }
        }
        return nil
    }
    
    public func calculatePositionInGraphicsBy(touchPoint: CGPoint) -> Bool {
        return customDrawLinePaths.filter { return $0.contains(touchPoint) }.count != 0
    }
}
