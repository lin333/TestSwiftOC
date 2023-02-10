//
//  qqqS.swift
//  Pods-TestSwiftOC_Example
//
//  Created by linbingjie on 2022/11/1.
//

import Foundation
//import Lottie

//@objcMembers
open class qqqS: NSObject {
    open var userid:Int = 10
    
    open func printtt() {
        print(userid)
        
        UseOC().useOC()
        
//        let vv = LottieColor(r: 1, g: 1, b: 1, a: 1)

    }
}


open class StudDetails {
    var stname: String!
    var mark1: Int!
    var mark2: Int!
    var mark3: Int!
    public init() {
        self.stname = "sdf"
        self.mark1 = 10
        self.mark2 = 30
        self.mark3 = 10
    }
}
