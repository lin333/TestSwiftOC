//
//  TBVarNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBVarNode: TBExproNode {
    public var name: String?
    public init(_ name: String) {
        super.init()
        self.name = name
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        guard data[name!] != nil else {
            return TBVarEntry(name:name!)
        }
        
        return data[name!]!
    }
    
    public func getVarEntry() -> Entry {
        return TBVarEntry(name:name!)
    }
}
