//
//  TBLLVNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBLLVNode: TBExproNode {
    var exprNode: TBExproNode?
    var N: TBExproNode?
    
    public init(_ lhs: TBExproNode,_ node4: TBExproNode) {
        super.init()
        self.exprNode = lhs
        self.N = node4
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let expr: [Double] = exprNode?.visit(data: &data).getEntry() as! [Double]
        let entry = buildEntry(data: data)
        let Nentry = N?.visit(data: &data)
        start = locateBadPointIndex(points: expr)
        let n: Int = Int(getValueByIndex(index: start, t2Entry: Nentry!))
        
        var res: [Double] = (entry.object)!
        var i = 0
        while i < res.count {
            var tmp = Double.greatestFiniteMagnitude
            var k = 0
            while k < n {
                if ((i - k) >= 0) {
                    tmp = min(expr[i - k], tmp)
                }
                res[i] = tmp
                k += 1
            }
            i += 1
        }
        
        entry.object = res
        return entry
        
    }
}
