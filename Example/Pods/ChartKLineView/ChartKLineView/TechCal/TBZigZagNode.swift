//
//  TBZigZag.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2020/4/2.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import Foundation

class TBZigZagNode: TBExproNode {
    
    var t1: TBExproNode?
    var t2: TBExproNode?
    var t3: TBExproNode?
    
    
    public init(_ t1: TBExproNode,_ t2: TBExproNode,_ t3: TBExproNode) {
        super.init()
        self.t1 = t1
        self.t2 = t2
        self.t3 = t3
    }
    
    override func visit(data: inout [String : Entry]) -> Entry {
        let entry: Entry = buildEntry(data: data)
        let close: [Double] = getValByType(tokenType: .CLOSE, data: data)?.getEntry() as! [Double]
        
        let result = TBZigZagNode.zigzag(arr: close, ext_depth: 12, ext_deviation: 0.05, ext_backstep: 3)
        
        
        var d_result = [Double]()
        for re in result {
            d_result.append(Double(re))
        }
        entry.object = d_result
        
        return entry
    }
    
    /// (高点索引， 低点索引）
    /// - Parameter a: <#a description#>
    class func extrmum(_ a: [Double]) -> (Int, Int) {
        
        let min = a.min()!
        let max =  a.max()!
        
        let min_i = a.index(of: min) ?? -1
        let max_i = a.index(of: max) ?? -1
        return (min_i, max_i)
    }
    
    /// 上涨方向，寻找下一个低点
    /// - Parameters:
    ///   - corner_index_list: <#corner_index_list description#>
    ///   - arr: <#arr description#>
    ///   - end: <#end description#>
    ///   - down_ext_deviation: <#down_ext_deviation description#>
    ///   - ext_backstep: <#ext_backstep description#>
    ///   - ext_depth: <#ext_depth description#>
    class func zigzag_low_corner(corner_index_list: inout [Int], arr: [Double], end: Int, down_ext_deviation: Double, ext_backstep: Int, ext_depth: Int) -> (Int, [Int]) {
        var pre_direction = 1
        var last_hight_value = arr[corner_index_list.last!]
        
        let current_bar_value = arr[end]
        if corner_index_list.count > 2 &&
            current_bar_value <= arr[corner_index_list[corner_index_list.count-2]] * down_ext_deviation {
            var back_count = 0
            // 区间内新低，back
            while (corner_index_list.count > 2 &&
                end - corner_index_list[corner_index_list.count-2] < ext_depth &&
                back_count < ext_backstep &&
                (current_bar_value <= arr[corner_index_list[corner_index_list.count-2]] * down_ext_deviation)) {
                    _ = corner_index_list.popLast()
                    _ = corner_index_list.popLast()
                    if corner_index_list.count <= 2 {
                        break
                    }
                    back_count += 2
                    last_hight_value = arr[corner_index_list.last!]
            }
            
            corner_index_list.append(end)
            pre_direction = -1
        } else if current_bar_value <= last_hight_value * down_ext_deviation
        {
            // 找到下一个低点
            corner_index_list.append(end)
            pre_direction = -1
        } else if current_bar_value >= last_hight_value {
            // 新高点，删除上一个高点， 添加新高点
            _ = corner_index_list.popLast()
            corner_index_list.append(end)
        }
        
        return (pre_direction, corner_index_list)
    }
    
    class func zigzag_hig_corner(corner_index_list: inout [Int], arr: [Double], end: Int, up_ext_deviation: Double, ext_backstep: Int, ext_depth: Int) -> (Int, [Int]) {
        // 下跌方向，寻找下一个高点
        var pre_direction = -1
        var last_low_value = arr[corner_index_list.last!]
        
        let current_bar_value = arr[end]
        if (corner_index_list.count > 2 &&
            current_bar_value >= arr[corner_index_list[corner_index_list.count-2]] * up_ext_deviation) {
            // 区间新高
            var back_count = 0
            while (corner_index_list.count > 2 &&
                end - corner_index_list[corner_index_list.count-2] < ext_depth &&
                back_count < ext_backstep &&
                current_bar_value >= arr[corner_index_list[corner_index_list.count-2]] * up_ext_deviation) {
                    _ = corner_index_list.popLast()
                    _ =  corner_index_list.popLast()
                    
                    back_count += 2
                    if corner_index_list.count <= 2 {
                        break
                    }
                    last_low_value = arr[corner_index_list.last!]
            }
            
            corner_index_list.append(end)
            pre_direction = 1
        }
        else if current_bar_value >= last_low_value * up_ext_deviation {
            corner_index_list.append(end)
            pre_direction = 1
        } else if current_bar_value <= last_low_value
        {
            // 新低点, 删掉上一个低点， 添加新低点
            _ = corner_index_list.popLast()
            corner_index_list.append(end)
        }
        
        return (pre_direction, corner_index_list)
        
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - arr: <#arr description#>
    ///   - ext_depth: 用于设置高低点是相对与过去多少个Bars而言
    ///   - ext_deviation: 用于设置重新计算高低点时，与前一高低点的相对点差。本算法仅反向翻转使用了精度，同向持续更新end_index
    ///   - ext_backstep: 用于设置回退计算的Bars的个数。
    class func zigzag(arr: [Double], ext_depth: Int = 12, ext_deviation: Double = 0.05, ext_backstep: Int = 3) -> [Int] {
        
        let up_ext_deviation = 1.0 + ext_deviation
        let down_ext_deviation = 1.0 - ext_deviation
        var corner_index_list: [Int] = [Int]()
        
        var pre_direction: Int = 0
        var start: Int = 0
        var end = ext_depth
        
        while true && end < arr.count {
            if end == ext_depth {
                // 第一次计算
                let tem = Array(arr[start...end])
                var (min_i, max_i) = extrmum(tem)
                min_i = min_i + start
                max_i = max_i + start
                
                if min_i < max_i {
                    corner_index_list.append(min_i)
                    corner_index_list.append(max_i)
                    pre_direction = 1
                } else {
                    corner_index_list.append(max_i)
                    corner_index_list.append(min_i)
                    pre_direction = -1
                }
            } else {
                if pre_direction <= 0 {
                    
                    (pre_direction, corner_index_list) = zigzag_hig_corner(corner_index_list: &corner_index_list, arr: arr, end: end, up_ext_deviation: up_ext_deviation, ext_backstep: ext_backstep, ext_depth: ext_depth)
                } else {
                    
                    (pre_direction, corner_index_list) = zigzag_low_corner(corner_index_list: &corner_index_list, arr: arr, end: end, down_ext_deviation: down_ext_deviation, ext_backstep: ext_backstep, ext_depth: ext_depth)
                }
            }
            
            start = start + 1
            end = start + ext_depth
            if end >= arr.count {
                break
            }
        }
        return corner_index_list
    }
    
}
