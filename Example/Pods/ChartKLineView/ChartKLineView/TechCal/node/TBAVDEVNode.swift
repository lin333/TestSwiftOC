//
//  TBAVDEVNode.swift
//  Stock
//
//  Created by luopengfei on 2018/4/25.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBAVDEVNode: TBExproNode {
    
    
    var t1: TBExproNode?
    var t2: TBExproNode?
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let eval: [Double] = t1?.visit(data: &data).getEntry()  as! [Double]
        let t2Entry = t2?.visit(data: &data)
        let start = locateBadPointIndex(points: eval)
        let n = getValueByIndex(index: start, t2Entry: t2Entry!)
        var res = [Double](repeating: 0.0, count: eval.count)
        MAD(data: eval, n: Int(n), result: &res)
        return Entry(object: res)
    }
    
    
    private func MAD(data: [Double], n: Int, result: inout [Double]) {
        var start = locateBadPointIndex(points: data)
        start += n
        let firstPoint = start - 1
        var sum: Double = 0.0
        var i = 0
        while (i < data.count && i < firstPoint) {
            result[i] = badPoint
            
            if i < firstPoint - n - 1 {
                i += 1
                continue
            }
            sum += data[i]
            i += 1
        }
        
        
        i = firstPoint
        while (i < data.count && i < result.count) {
            sum += data[i]
            result[i] = sum / Double(n)
            var tmpSum = 0.0
            
            var j = 0
            while j < n {
                tmpSum += fabs(data[i - j] - result[i])
                j += 1
            }
            result[i] = tmpSum / Double(n)
            sum -= data[i-n+1]
            
            i += 1
        }
    }
    
}
