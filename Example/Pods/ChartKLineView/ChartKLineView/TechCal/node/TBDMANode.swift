//
//  TBDMANode.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/3.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBDMANode: TBExproNode {
    var t1: TBExproNode?
    var t2: TBExproNode?
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
    }
    
    override func visit(data: inout [String : Entry]) -> Entry {
        let eval = t1?.visit(data: &data).getEntry() as! [Double]
        let t2Entry = t2?.visit(data: &data)
        let start = locateBadPointIndex(points: eval)
        let N = getValueByIndex(index: start, t2Entry: t2Entry!)
        var res =  [Double](repeating: 0.0, count: eval.count)
        DMA(eval, N, &res, start)
        return Entry(object: res)
    }
    
    private func DMA(_ eval: [Double], _ timePeriod: Double, _ res: inout [Double],_ start: Int) {
        for i in start..<eval.count {
            if i == start {
                res[i] = eval[i]
            } else {
                res[i] =  eval[i] * (timePeriod) + (1 - timePeriod) * eval[i - 1]
            }
        }
    }
}
