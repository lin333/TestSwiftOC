//
//  TBABSNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBABSNode: TBExproNode {
    open var exprNode: TBExproNode?
    
    public init(_ lhs: TBExproNode) {
        super.init()
        self.exprNode = lhs
    }
    
    override func visit(data: inout [String : Entry]) -> Entry {
        let exprs: [Double] = exprNode?.visit(data: &data).getEntry() as! [Double]
        let entry = buildEntry(data: data)
        var res: [Double] = (entry.object)!
        var i = 0
        while  i < res.count {
            res[i] = Double(fabs(exprs[i]))
            i += 1
        }

        entry.object = res
        return entry
    }
    
    
}
