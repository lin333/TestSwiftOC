//
//  TBPCNT.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBPCNT: NSObject, TBCalculable {
    let code: String = "PCNT:(CLOSE-REF(CLOSE,1))/CLOSE*100;\n" + "MAPCNT:EMA(PCNT,M);\n"
        
        func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
    //        let param: [Int] = <#value#>
            /// TODO: 指标范围添加
            data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "PCNT"))
            return TBCalcUtils.run(code: code, data: &data)
        }
}
