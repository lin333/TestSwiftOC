//
//  TBLogicOrNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBLogicOrNode: TBExproNode {

    var l: TBExproNode?
    var r: TBExproNode?
    
    public init(_ l: TBExproNode,_ r: TBExproNode) {
        super.init()
        self.l = l
        self.r = r
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
   
        let ls: [Double] = l?.visit(data: &data).getEntry() as! [Double]
        var rs: [Double] = r?.visit(data: &data).getEntry() as! [Double]
        let entry = buildEntry(data: data)
        var res: [Double] = entry.getEntry() as! [Double]
        
        var i = 0
        while i < res.count {
            if (ls[i] == 1 || rs[i] == 1) {
                res[i] = 1
            } else {
                res[i] = 0
            }
            i += 1
        }
        
        entry.object = res
        return entry
        
    }
    
    
    
}
