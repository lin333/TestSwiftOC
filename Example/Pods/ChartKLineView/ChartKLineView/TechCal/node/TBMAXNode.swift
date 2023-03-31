//
//  TBMAXNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBMAXNode: TBExproNode {
    var t1: TBExproNode?
    var t2: TBExproNode?
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let eval1 = t1?.visit(data: &data)
        let eval2 = t2?.visit(data: &data)
        
        let entry: Entry = buildEntry(data: data)
        var res: [Double] = entry.object!
        var i = 0
        while  i < res.count {
            res[i] = max(getValueByIndex(index: i, t2Entry: eval1!), getValueByIndex(index: i, t2Entry: eval2!))
            i+=1
        }
       
        entry.object = res
        return entry
    }
}
