//
//  TBUnaryOpNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBUnaryOpNode: TBExproNode {
    var exprNode: TBExproNode?
    var op: String = ""
    
    public init(_ op: String,_ expr: TBExproNode) {
        self.exprNode = expr
        self.op = op
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let exprs: [Double] = exprNode?.visit(data: &data).getEntry() as! [Double]
        let entry = buildEntry(data: data)
        var res: [Double] = entry.getEntry() as! [Double]
        var i = 0
        while i < res.count {
            if op == "-" {
                res[i] = -exprs[i]
            }
            i += 1
        }
        
        entry.object = res
        return entry
    }
}
