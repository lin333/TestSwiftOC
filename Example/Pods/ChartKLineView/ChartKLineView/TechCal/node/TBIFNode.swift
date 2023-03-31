//
//  TBIFNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBIFNode: TBExproNode {
    var expr: TBExproNode?
    var v1: TBExproNode?
    var v2: TBExproNode?
    
    public init(_ expr: TBExproNode,_ v1: TBExproNode,_ v2: TBExproNode) {
        super.init()
        self.expr = expr
        self.v1 = v1
        self.v2 = v2
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let exprs: [Double] = expr?.visit(data: &data).getEntry() as! [Double]
        let entry: Entry = buildEntry(data: data)
        var res: [Double] = entry.getEntry() as! [Double]
        let visit = v1?.visit(data: &data)
        var v1s = [Double]()
        
        if visit!.isConstant() {
            let val = visit?.getEntry() as! Double
            v1s = Array(repeating: val, count: exprs.count)
        } else {
            v1s = visit?.getEntry() as! [Double]
        }
        
        let t2Entry = v2?.visit(data: &data)
        
        start = max(locateBadPointIndex(points: v1s), locatedBadPointIndex(t2Entry: t2Entry!))
        
        var i = start
        while i < res.count {
            if (exprs[i] == 1) {
                res[i] = v1s[i]
            } else {
                res[i] = getValueByIndex(index: i, t2Entry: t2Entry!)
            }
            i += 1
        }
        entry.object = res
        return entry
        
    }
    
    
    
}
