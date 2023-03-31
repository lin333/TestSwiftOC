//
//  TBExprStmtNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBExprStmtNode: TBStmtNode {
    var e: TBExproNode?
    
    /**
     * 增加结果修改符,如颜色、图形形状等
     */
    public func addDecorate(decorate: String) {
        if e is TBAssignNode {
            let tmpE: TBAssignNode = e as! TBAssignNode
            tmpE.decorate.append(TBDecoration.getDecoration(str: decorate))
        }
    }
    
    override func evalE(data: inout [String : Entry]) -> Any {
        return e?.visit(data: &data) as Any
    }
    
    
    override func evalE(data: inout [String : Entry], i: Int) -> Any {
        if e is TBNewAssignNode {
            
            let tmpE: TBNewAssignNode = e as! TBNewAssignNode
            _ = tmpE.evalE(data: &data, i: i)
        }
        
        return -1
    }
    
    public init(e: TBExproNode) {
        super.init()
        self.e = e
    }
}
