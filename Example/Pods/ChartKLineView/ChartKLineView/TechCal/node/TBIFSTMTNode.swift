//
//  TBIFSTMTNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBIFSTMTNode: TBExproNode {
    var expr: TBExproNode?
    var stmt: [TBStmtNode]?
    
    public init(_ expr: TBExproNode,_ stmt: [TBStmtNode]) {
        super.init()
        self.expr = expr
        self.stmt = stmt
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let exprs: [Double] = expr?.visit(data: &data).getEntry() as! [Double]
        let entry: Entry = buildEntry(data: data)
        start = locateBadPointIndex(points: exprs)
        let res: [Double] = (entry.object)!
        
        var i = start
        while i < res.count {
            if exprs[i] == 1 {
                for stmtNode in stmt! {
                    _ = stmtNode.evalE(data: &data, i: i)
                }
            }
            
            i += 1
        }
        
        entry.object = res
        return entry
        
    }
    
}
