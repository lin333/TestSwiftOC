//
//  UseOC.swift
//  TestSwiftOC
//
//  Created by linbingjie on 2022/11/1.
//

import Foundation
import Moya
public class UseOC {
    public init() {
        
    }
    
    public func useOC() {
        LBJOC.loglog2()
        
        MultiTarget.target(TargetType.self as! TargetType)

    }
}
