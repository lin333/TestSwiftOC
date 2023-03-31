//
//  TBExprNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/19.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import Foundation

open class TBExproNode: NSObject {
    public let badPoint = Double.nan
    
    public var start: Int = Int(0)
    
    public var evalE: Entry?
    
    public func visit(data: inout [String: Entry]) -> Entry {
        fatalError("sub class")
    }
    
    public func evalE( data: inout [String: Entry]) -> Entry {
        fatalError("abstract func")
    }
    
    public func getValByType(tokenType: TBTokenType, data: [String: Entry]) -> Entry? {
        switch tokenType {
        case .HIGH:
            return data["high"]!
        case .CLOSE:
            return data["close"]!
        case .LOW:
            return data["low"]!
        case .OPEN:
            return data["open"]!
        case .VOL:
            return data["vol"]!
        default:
            return nil
        }
    }
    
    public func buildEntry(data: [String: Entry]) -> Entry {
        let e = data["high"]?.getEntry() as! [Double]
        return Entry(object:[Double](repeating: 0.0, count: e.count))
    }
    
    public func buildConstantEntry(data: Double) -> Entry {
        return TBConstantEntry(value: data)
    }
    
    public func getValueByIndex(index: Int, t2Entry: Entry) -> Double {
        let value = t2Entry.getEntry()
        if t2Entry.isConstant() {
            if value is Int {
                return Double(value as! Int)
            }
            return value as! Double
        }
        let values = t2Entry.object!
        guard index < values.count else {
            return badPoint
        }
        return values[index]

    }
    
    public func locatedBadPointIndex(t2Entry: Entry) -> Int {
        if t2Entry.isConstant() {
            return 0
        }
        
        return locateBadPointIndex(points: t2Entry.object!)
    }
    
    public func locateBadPointIndex(points: [Double]) -> Int {
        var i = 0
        while i < points.count {
            if !points[i].isNaN {
                return i
            }
            i += 1
        }
        return points.count
    }
    
    
    private func sum(_ a: Double, _ b: Double) -> Double {
        return a+b
    }
    private func multiply(_ a: Double, _ b: Double) -> Double {
        return a*b
    }
    private func except(_ a: Double, _ b: Double) -> Double {
        if b == 0 {
            return 0
        }
        return a/b
    }
    private func greaterThan(_ a: Double, _ b: Double) -> Double {
        if a > b {
            return 1
        }
        return 0
    }
    
    private func greaterThanOrEqualTo(_ a: Double, _ b: Double) -> Double {
        if a >= b {
            return 1
        }
        return 0
    }
    
    private func lessThan(_ a: Double, _ b: Double) -> Double {
        if a < b {
            return 1
        }
        return 0
    }
    
    private func lessThanOrEqualTo(_ a: Double, _ b: Double) -> Double {
        if a <= b {
            return 1
        }
        return 0
    }
    
    private func notEqualTo(_ a: Double, _ b: Double) -> Double {
        if a != b {
            return 1
        }
        return 0
    }
    
    private func equalTo(_ a: Double, _ b: Double) -> Double {
        if a == b {
            return 1
        }
        return 0
    }
    
    private func diff(_ a: Double, _ b: Double) -> Double {
        return a-b
    }
    
    public func operation(_ op: String) -> ((Double,Double)->Double)? {
        if op == "+" {
            return sum
        } else if op == "-" {
            return diff
        } else if op == "*" {
            return multiply
        } else if op == "/" {
            return except
        } else if op == ">" {
            return greaterThan
        } else if op == "<" {
            return lessThan
        } else if op == ">=" {
            return greaterThanOrEqualTo
        } else if op == "<=" {
            return lessThanOrEqualTo
        } else if op == "!=" {
            return notEqualTo
        } else if op == "==" {
            return equalTo
        }
        return nil
    }
        
}
