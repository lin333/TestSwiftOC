//
//  TBSTDNode.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/24.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBSTDNode: TBExproNode {

    var t1: TBExproNode?
    var t2: TBExproNode?
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
    }
    
    override func visit(data: inout [String: Entry]) -> Entry {
        let eval: [Double] = t1?.visit(data: &data).getEntry() as! [Double]
        let t2Entry: Entry = (t2?.visit(data: &data))!
        start = locateBadPointIndex(points: eval)
        let N: Int = Int(getValueByIndex(index: start, t2Entry: t2Entry))
        let res = std(eval: eval, n: N)
        return Entry(object: res)
        
    }
    
    public func std(eval: [Double], n: Int) -> [Double] {
        var res: [Double] = [Double](repeating: 0.0, count: eval.count)
        var mas: [Double] = [Double](repeating: 0.0, count: eval.count)
        
        self.ma(data: eval, n: n, result: &mas)
        
        start = locateBadPointIndex(points: mas)
        var startSum = max(start, locateBadPointIndex(points: eval))

        var i = startSum
        while i < mas.count {
            var period = 0.0
            var j = 0
            while j < n && j < startSum {
                period += pow((eval[startSum - j] - mas[startSum]), 2)
                j += 1
            }
            period /= Double(n)
            res[i] = sqrt(period)
            startSum += 1
            i += 1
        }
        
        return res
    }
    
    private func ma(data: [Double], n: Int, result: inout [Double]) {
        let firPoint: Int = start - 1 + n
        var sum: Double = 0
        var i = firPoint - n + 1
        while (i < data.count && i < firPoint) {
            sum += data[i]
            result[i] = Double(badPoint)
            i+=1
        }
        
        var j = firPoint
        
        while (j < data.count && j < result.count) {
            sum += data[j]
            result[j] = sum / Double(n)
            sum -= data[j-n+1]
            j+=1
        }
        
    }
}
