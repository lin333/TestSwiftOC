//
//  TBBIAS.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBBIAS: NSObject, TBCalculable {
    let code: String = "BIAS$1 :(CLOSE-MA(CLOSE,N1))/MA(CLOSE,N1)*100;\n" + "BIAS$2 :(CLOSE-MA(CLOSE,N2))/MA(CLOSE,N2)*100;\n" +
    "BIAS$3 :(CLOSE-MA(CLOSE,N3))/MA(CLOSE,N3)*100;\n"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
//        let param: [Int] = <#value#>
        /// TODO: 指标范围添加
        data["N1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "BIAS"))
        data["N2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "BIAS"))
        data["N3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "BIAS"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
