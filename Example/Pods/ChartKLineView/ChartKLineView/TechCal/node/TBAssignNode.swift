//
//  TBAssignNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBAssignNode: TBExproNode {
    
    var rhs: TBExproNode?
    var lhs: TBVarNode?
    var decorate: [TBDecoration] = [TBDecoration]()
    
    public init(_ lhs: TBExproNode,_ rhs: TBExproNode) {
        super.init()
        self.rhs = rhs
        self.lhs = (lhs as! TBVarNode)
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {

        let value = rhs?.visit(data: &data)
        value?.decorations = decorate
        value?.isResult = true
        let name = lhs?.getVarEntry().getEntry() as! String
        data[name] = value!
        return value!
        
    }
    
    
    
    
}
