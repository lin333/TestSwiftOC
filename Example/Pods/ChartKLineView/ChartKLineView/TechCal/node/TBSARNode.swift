//
//  TBSARNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBSARNode: TBExproNode {
    var t1: TBExproNode?
    var t2: TBExproNode?
    var t3: TBExproNode?
    
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode,_ t3: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
    
    
    override func visit(data: inout [String : Entry]) -> Entry {
        let entry: Entry = buildEntry(data: data)
        let close: [Double] = getValByType(tokenType: .CLOSE, data: data)?.getEntry() as! [Double]
        var res = [Double](repeating: Double.nan, count: close.count)
        let n = t1?.visit(data: &data).getEntry() as! Int
        let maxAf = Double(t2?.visit(data: &data).getEntry() as! Int) / 100.0
        let minAf = Double(t3?.visit(data: &data).getEntry() as! Int) / 100.0
        
        SAR(n: n, minAf: minAf, maxAf: maxAf, res: &res, data: data)
        
        entry.object = res
        return entry
    }
    
    private func SAR(n: Int, minAf: Double, maxAf: Double, res: inout [Double], data: [String: Entry]){
        let high: [Double] = getValByType(tokenType: .HIGH, data: data)?.getEntry() as! [Double]
        let low: [Double] = getValByType(tokenType: .LOW, data: data)?.getEntry() as! [Double]
        
        let start = locateBadPointIndex(points: high)
        var isRevert = false
        
        var af: [Double] = [Double](repeating: 0.0,count:low.count)
        var sarp: [Double] = [Double](repeating: Double.nan, count: low.count)
        var epLow: [Double] = [Double](repeating: 0.0, count: low.count)
        var epHigh: [Double] = [Double](repeating: 0, count: low.count)
        var direc: [Int] = [Int](repeating: 0, count: low.count)
        
        for i in start..<res.count {
            if (i + 1 < n) {
                isRevert = false
                direc[i] = 1
            } else if (i + 1 == n) {
                af[i] = minAf
                isRevert = false
                direc[i] = 1
                epHigh[i] = -Double.infinity
                epLow[i] = Double.infinity
                // hhv llv
                for j in 0..<i {
                    epHigh[i] = max(high[j], epHigh[i])
                    epLow[i] = min(low[j], epLow[i])
                }
                if (low[i] > epLow[i]) {
                    sarp[i] = epLow[i]
                } else {
                    isRevert = true
                    direc[i] = 0
                    sarp[i] = epHigh[i]
                }
            } else if (i + 1 > n) {
                epHigh[i] = -Double.infinity
                epLow[i] = Double.infinity
                for j in (i-n+1)...i {
                    epHigh[i] = max(high[j], epHigh[i])
                    epLow[i] = min(low[j], epLow[i])
                }
                if (direc[i - 1] == 1) {
                    if (low[i] < sarp[i - 1] + af[i - 1] * (epHigh[i - 1] - sarp[i - 1])) {
                        direc[i] = 0
                    } else {
                        direc[i] = 1
                    }
                } else {
                    if (high[i] > sarp[i-1] + af[i-1] * (epLow[i-1] - sarp[i-1])) {
                        direc[i] = 1
                    } else {
                        direc[i] = 0
                    }
                }
                if (direc[i - 1] != direc[i]) {
                    isRevert = true
                } else {
                    isRevert = false
                }
                
                
                // af factor calculating
                if (isRevert) {
                    af[i] = minAf
                } else {
                    if (direc[i] == 1) {
                        if (epHigh[i] > epHigh[i - 1]) {
                            af[i] = af[i - 1] + minAf
                        } else {
                            af[i] = af[i - 1]
                        }
                    } else {
                        if (epLow[i] < epLow[i - 1]) {
                            af[i] = af[i - 1] + minAf
                        } else {
                            af[i] = af[i - 1]
                        }
                    }
                }
                
                if (af[i] > maxAf) {
                    af[i] = maxAf
                }
                
                if (!isRevert) {
                    if (direc[i] == 1) {
                        sarp[i] = sarp[i - 1] + af[i - 1] * (epHigh[i] - sarp[i - 1])
                    } else {
                        sarp[i] = sarp[i - 1] + af[i - 1] * (epLow[i] - sarp[i - 1])
                    }
                } else {
                    if (direc[i] == 1) {
                        sarp[i] = epLow[i]
                    } else {
                        sarp[i] = epHigh[i]
                    }
                }
            }
            
        }
        
        for i in start..<res.count {
            res[i] = sarp[i]
        }
    }
    
}
