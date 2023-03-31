//
//  TBTechnicalIndexUtils.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/20.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import Foundation

extension String {
    
    /// 字符串长度
    ///
    /// - Returns: 字符串长度
//    public func length() -> Int {
//        guard !self.isEmpty else {
//            return 0
//        }
//        return self.characters.count
//    }
    
    /// 索引处Character
    ///
    /// - Parameter index: 索引
    /// - Returns: Character
    public func charAt(index: Int) -> Character {
        let n = self.index(self.startIndex, offsetBy: index, limitedBy: self.endIndex)
        return self[n!]
    }
    
    
    
    /// String to Double
    ///
    /// - Returns: Double Value
    public func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        let tmpDouble = numberFormatter.number(from: self)?.doubleValue
        guard (tmpDouble != nil) else {
            return Double(0.0)
        }
        return tmpDouble
    }
    
    /// String to Int
    ///
    /// - Returns: Int Value
    public func toInt() -> Int? {
        let numberFormmater = NumberFormatter()
        let tmpInt = numberFormmater.number(from: self)?.intValue
        guard (tmpInt != nil) else {
            return Int(0)
        }
        return tmpInt
    }
}

extension Character {
    
    /// Character 是否为数字
    ///
    /// - Returns: Bool
//    public func isDigist() -> Bool {
//        // 系统提供一个方法，目前使用自己写的（"0"..."9" ~= self）进行判断
////        let digistSet = CharacterSet.decimalDigits
////        let StrSelf = self.description
////        for c in StrSelf.unicodeScalars {
////            if digistSet.contains(c) {
////                return true
////            }
////        }
//
//        if "0"..."9" ~= self {
//            return true
//        }
//        return false
//    }

    /// Character 是否为字符 or 数字
    ///
    /// - Returns: Bool
    public func isLetterOrDigit() -> Bool {
        return (self.isLetter || self.isNumber)
    }
    
//    public func isUpperCase() -> Bool {
//        self.isUppercase
//        if "A" ... "Z" ~= self {
//            return true
//        }
//        return false
//    }
    
    
    /// get char ascii value
    var asciiValue: Int {
        get {
            let c = String(self).unicodeScalars
            return Int(c[c.startIndex].value)
        }
    }
    
    
}


/// 实现一个Int stack,官方推荐的一种实现方式
/// https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Generics.html
struct IntStack {
    var items = [Int]()
    mutating func push(item: Int) {
        items.append(item)
    }
    
    mutating func pop() -> Int {
        return items.removeLast()
    }
    
    mutating func append(item: Int) {
        self.push(item: item)
    }
    
    var count: Int {
        return items.count
    }
    
    public func subscripts(i: Int) -> Int {
        return items[i]
    }
    
}


// MARK: - swift3.0 将++ -- 废弃
// 采用下面的方式实现
extension Int {
//    prefix operator ++
//    postfix operator ++
//    
//    prefix operator -- {}
//    postfix operator -- {}
    // 加➕
    @discardableResult static prefix func ++( x: inout Int) -> Int {
        x += 1
        return x
    }
    
    @discardableResult static postfix func ++( x: inout Int) -> Int {
        x += 1
        return (x - 1)
    }
    

    // 减➖
    @discardableResult static prefix func --( x: inout Int) -> Int {
        x -= 1
        return x
    }
    
    @discardableResult static postfix func --( x: inout Int) -> Int {
        x -= 1
        return (x + 1)
    }
}
