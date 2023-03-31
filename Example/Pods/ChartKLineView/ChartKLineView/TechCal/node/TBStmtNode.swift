//
//  TBStmtNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/7.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBStmtNode: NSObject {
    
    public func evalE(data: inout [String : Entry]) -> Any {
        fatalError("abstract")
    }
    
    public func evalE(data: inout [String: Entry],i: Int) -> Any {
        fatalError("abstract")
    }
    
}
