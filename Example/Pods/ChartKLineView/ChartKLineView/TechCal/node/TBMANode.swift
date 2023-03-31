//
//  TBMANode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBMANode: TBExproNode {
    var t1: TBExproNode?
    var t2: TBExproNode?
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {

        let eval: [Double] = (t1?.visit(data: &data).object)!
        
        let t2Entry: Entry = (t2?.visit(data: &data))!
        let start: Int = locateBadPointIndex(points: eval)
        
        let N: Int = Int(getValueByIndex(index: start, t2Entry: t2Entry))
        let res = ma(data: eval, n: N)
        let entry = Entry(object: res)
        return entry
    }
    
    private func ma(data: [Double], n: Int) -> [Double] {
        var result: [Double] = [Double](repeating: 0.0, count: data.count)
        var start: Int = locateBadPointIndex(points: data)
        start += n
        let firPoint: Int = start - 1
        var i: Int = 0
        var sum: Double = 0.0
        while (i < data.count && i < firPoint) {
            result[i] = Double(badPoint)
            if (i < firPoint - n + 1) {
                i += 1
                continue
            }
            sum += data[i]
            i += 1
        }
        
        i = firPoint
        while (i < data.count && i < result.count) {
            sum += data[i]
            result[i] = sum / Double(n)
            sum -= data[i-n+1]
            i += 1
        }
        
        return result
        
    }
}
