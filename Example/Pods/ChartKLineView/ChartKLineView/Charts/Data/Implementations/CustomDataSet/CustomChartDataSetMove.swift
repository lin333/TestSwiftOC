//
//  CustomChartDataSetMove.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/27.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

extension CustomChartDataSet: ICustomChartDataSetMove {
    public func totalGraphicstMoveBy(with translation: CGPoint) {
        entries.forEach {
            $0.changeValue(with: Double(translation.x), y: Double(translation.y))
        }
    }
    
    public func singleEntryMoveBy(editEntry: CustomChartDataEntry?, translation: CGPoint) {
        if let entry = editEntry {
            entry.changeValue(with: Double(translation.x), y: Double(translation.y))
            calculateMagnetEntry(entry: entry, changeValueDiff: Double(translation.y))
            correctOtherPointsBy(entry: entry)
        }
    }

    public func appendClosedGraphicsPathLocation(entries: [ChartDataEntry]) {
        if entries.count > 0 {
            customDrawLinePaths.append(UIBezierPath.closedGraphicsPath(path: entries))
        }
    }

    public func appendSinglePathLocation(points: [CGPoint], maxDiffValue: CGFloat) {
        if entries.count > 0 {
            customDrawLinePaths.append(UIBezierPath.singleLinePath(points: points, maxDiffValue: maxDiffValue))
        }
    }
    
    public func clearPathLocation() {
        customDrawLinePaths.removeAll()
    }
}
