//
//  TBBrokenLineNode.swift
//  Stock
//
//  Created by luopengfei on 2018/4/25.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBBrokenLineNode: TBExproNode {

    var rhs: TBExproNode?
    var lhs: TBVarNode?
    
    public init(_ rhs : TBExproNode,_ lhs: TBVarNode) {
        super.init()
        
        self.rhs = rhs
        self.lhs = lhs
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        var value = rhs?.visit(data: &data)
        let name = lhs?.getVarEntry().getEntry() as! String
        
        let valueName: String = ((rhs is TBVarNode) ? (rhs as! TBVarNode).name! : "")
        if data.keys.contains(valueName) {
            let paramEntry = data[valueName] as! TBParamEntry
            let val = paramEntry.getEntry() as! Int
            let entry = buildEntry(data: data)
            var res = (entry.object)!
            var i = 0
            while i < res.count {
                res[i] = Double(val)
                i += 1
            }
            entry.object = res
            value = entry
        }
        
        value?.isResult = true
        var decorations = [TBDecoration]()
        
        decorations.append(TBDecoration.BROKENLINE)
        value?.decorations = decorations
        data[name] = value
        return value!
    }
    
}
