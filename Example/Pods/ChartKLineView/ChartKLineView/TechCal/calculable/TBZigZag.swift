//
//  TBZigZag.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2020/4/4.
//  Copyright © 2020 luopengfei. All rights reserved.
//

import UIKit

class TBZigZag: NSObject, TBCalculable {
    let code: String = "ZigZag1:ZigZag(12,0.05,3);"
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        return TBCalcUtils.run(code: code, data: &data)
    }
}
