//
//  CustomChartDataSetDraw.swift
//  TBMixedChartView
//
//  Created by JustLee on 2020/3/27.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

extension CustomChartDataSet: ICustomChartDataSetDraw {
    
    open func addCustomEntry(entry: CustomChartDataEntry?) {
        if let entry = entry {
            append(entry)
        }
    }

    open func completeCurrentCustomDrawing() -> Bool {
        if customDrawLineType.compeleteCount == entries.count {
            if customDrawLineType.needSupplyGraphicsPoint {
                supplyGraphicsPoints()
            }
            
            return true
        }
        return false
    }
    
    open func supplyGraphicsPoints() {
        switch customDrawLineType {
            
        case .rectangle:
            let pointa1 = entries.first!
            let pointa3 = entries.last!
            let pointa2 = CustomChartDataEntry(hidingEntry: pointa1.x, y: pointa3.y)
            let pointa4 = CustomChartDataEntry(hidingEntry: pointa3.x, y: pointa1.y)
            replaceEntries([pointa1, pointa2, pointa3, pointa4])
        break
            
        default: break
            
        }
    }
    
    open func generateDisplayEntries(xRange: Range, yRange: Range) {
        
    }
    
    open func calculateMagnetEntry(entry: CustomChartDataEntry?, changeValueDiff: Double) {
        
        if  let entry = entry,
            let combinedEntry = entry.combinedEntry as? CandleChartDataEntry,
            round(entry.x) == combinedEntry.x,
            customDrawMagnetEnable {
            
            ///磁吸的条件
            switch entry.y {
            
            case (combinedEntry.high - combinedEntry.shadowRange * 0.15)...combinedEntry.high:
                if changeValueDiff > 0 {
                    entry.resetValue(with: entry.x, y: combinedEntry.high)
                }
            case combinedEntry.high...(combinedEntry.high + combinedEntry.shadowRange * 0.15):
                if changeValueDiff < 0 {
                    entry.resetValue(with: entry.x, y: combinedEntry.high)
                }
                
            case combinedEntry.low...(combinedEntry.low + combinedEntry.shadowRange * 0.15):
                if changeValueDiff < 0 {
                    entry.resetValue(with: entry.x, y: combinedEntry.low)
                }
                
            case (combinedEntry.low - combinedEntry.shadowRange * 0.15)...combinedEntry.low:
                if changeValueDiff > 0 {
                    entry.resetValue(with: entry.x, y: combinedEntry.low)
                }
                
            case combinedEntry.open...(combinedEntry.open + combinedEntry.bodyRange * 0.15):
                if changeValueDiff < 0 {
                    entry.resetValue(with: entry.x, y: combinedEntry.open)
                }
                
            case (combinedEntry.open - combinedEntry.bodyRange * 0.15)...combinedEntry.open:
                if changeValueDiff > 0 {
                    entry.resetValue(with: entry.x, y: combinedEntry.open)
                }
                
            case combinedEntry.close...(combinedEntry.close + combinedEntry.bodyRange * 0.15):
                if changeValueDiff < 0 {
                    entry.resetValue(with: entry.x, y: combinedEntry.close)
                }
                
                
            case (combinedEntry.close - combinedEntry.bodyRange * 0.15)...combinedEntry.close:
                if changeValueDiff > 0 {
                    entry.resetValue(with: entry.x, y: combinedEntry.close)
                }
                
            default: break
            }
        }
    }
    
    open func correctOtherPointsBy(entry: CustomChartDataEntry?) {
        if let entry = entry {
            switch customDrawLineType {
            case .rectangle:
                let index = entries.firstIndex(of: entry)
                
                switch index {
                case 0:
                    let pointa1 = entries[1]
                    let pointa3 = entries[3]
                    pointa1.resetValue(with: entry.x, y: pointa1.y)
                    pointa3.resetValue(with: pointa3.x, y: entry.y)
                    break
                case 1:
                    let pointa0 = entries[0]
                    let pointa2 = entries[2]
                    pointa0.resetValue(with: entry.x, y: pointa0.y)
                    pointa2.resetValue(with: pointa2.x, y: entry.y)
                    break
                    
                case 2:
                    let pointa1 = entries[1]
                    let pointa3 = entries[3]
                    pointa3.resetValue(with: entry.x, y: pointa3.y)
                    pointa1.resetValue(with: pointa1.x, y: entry.y)
                    break
                    
                case 3:
                    let pointa0 = entries[0]
                    let pointa2 = entries[2]
                    pointa2.resetValue(with: entry.x, y: pointa2.y)
                    pointa0.resetValue(with: pointa0.x, y: entry.y)
                    break
                default:
                    break
                }
                break
                
            default:
                break
            }
        }
    }
}
