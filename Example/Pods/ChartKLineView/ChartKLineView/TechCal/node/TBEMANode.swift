//
//  TBEMANode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBEMANode: TBExproNode {
    var t1: TBExproNode?
    var t2: TBExproNode?
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
    }
    
    
    private func ema(eval: [Double], timePeriod: Double, res: inout [Double], start: Int) {
        
        var i = start
        while i < res.count {
            if i==start {
                res[i] = eval[i]
            } else {
                res[i] = (eval[i] * 2 + res[i-1] * (timePeriod-1)) / (timePeriod+1)
            }
            i += 1
        }
        
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let eval = t1?.visit(data: &data).object!
        let t2Entry = t2?.visit(data: &data)
        let start = locateBadPointIndex(points: eval!)
        let n = getValueByIndex(index: start, t2Entry: t2Entry!)
        var res = [Double](repeating: 0.0, count: (eval?.count)!)
        
        ema(eval: eval!, timePeriod: Double(n), res: &res, start: start)
        
        return Entry(object: res)
    }
    
}
