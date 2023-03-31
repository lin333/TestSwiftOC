//
//  TBROC.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBROC: NSObject, TBCalculable {
    let code: String = "ROC:100*(CLOSE-REF(CLOSE,N))/REF(CLOSE,N);\n" + "MAROC:MA(ROC,M);\n"
        
        func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
    //        let param: [Int] = <#value#>
            /// TODO: 指标范围添加
            data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "ROC"))
            data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "ROC"))

            return TBCalcUtils.run(code: code, data: &data)
        }
}
