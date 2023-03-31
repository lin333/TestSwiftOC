//
//  TBLocation.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/20.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBLocation: NSObject {

    fileprivate var sourceName: String?
    fileprivate var token: TBToken?
    
    public init(initSourceName: String, initToken: TBToken) {
        super.init()
        self.sourceName = initSourceName
        self.token = initToken
    }
    
    public func getSourceName() -> String? {
        return sourceName
    }
    
    public func getToken() -> TBToken? {
        return token
    }
}
