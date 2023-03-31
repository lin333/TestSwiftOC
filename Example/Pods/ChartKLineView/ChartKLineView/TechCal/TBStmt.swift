//
//  TBStmt.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/20.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBStmt: NSObject {
    fileprivate var location: TBLocation?
    public init(initLocation: TBLocation) {
        super.init()
        self.location = initLocation
    }
    
    public func getLocation() -> TBLocation {
        return location!
    }
}
