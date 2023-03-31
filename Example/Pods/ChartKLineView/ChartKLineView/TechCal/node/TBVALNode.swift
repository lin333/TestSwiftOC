//
//  TBVALNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBVALNode: TBExproNode {

    var tokenType: TBTokenType?
    public init(_ token: TBTokenType) {
        super.init()
        self.tokenType = token
    }
    
    override func visit(data: inout [String : Entry]) -> Entry {
        return getValByType(tokenType: tokenType!, data: data)!
    }
}
