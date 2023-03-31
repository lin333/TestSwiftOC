//
//  TBHHVNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBHHVNode: TBExproNode {
    var exprNode: TBExproNode?
    var N: TBExproNode?
    
    public init(_ lhs: TBExproNode,_ node4: TBExproNode) {
        super.init()
        self.exprNode = lhs
        self.N = node4
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let exprs: [Double] = exprNode?.visit(data: &data).getEntry() as! [Double]
        start = locateBadPointIndex(points: exprs)
        let entry: Entry = buildEntry(data: data)
        let NEntry: Entry = (N?.visit(data: &data))!
        let n: Int = Int(getValueByIndex(index: start, t2Entry: NEntry))

        var res: [Double] = entry.getEntry() as! [Double]
        var i = 0
        while i < res.count {
            var tmp: Double = -.greatestFiniteMagnitude
            var k = 0
            while k < n {
                if (i-k)>=0 {
                    tmp = max(exprs[i-k], tmp)
                }
                k += 1
            }
            res[i] = tmp
            i += 1
        }
        entry.object = res
        return entry
    }
}
