//
//  TBPBX.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBPBX: NSObject, TBCalculable {

    let code: String = "PBX$1:(EMA(CLOSE,M1)+MA(CLOSE,M1*2)+MA(CLOSE,M1*4))/3;PBX$2:(EMA(CLOSE,M2)+MA(CLOSE,M2*2)+MA(CLOSE,M2*4))/3;PBX$3:(EMA(CLOSE,M3)+MA(CLOSE,M3*2)+MA(CLOSE,M3*4))/3;PBX$4:(EMA(CLOSE,M4)+MA(CLOSE,M4*2)+MA(CLOSE,M4*4))/3;PBX$5:(EMA(CLOSE,M5)+MA(CLOSE,M5*2)+MA(CLOSE,M5*4))/3;PBX$6:(EMA(CLOSE,M6)+MA(CLOSE,M6*2)+MA(CLOSE,M6*4))/3;"
        
        func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
            data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "PBX"))
            data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "PBX"))
            data["M3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "PBX"))
            data["M4"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "PBX"))
            data["M5"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 4, key: "PBX"))
            data["M6"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 5, key: "PBX"))

            return TBCalcUtils.run(code: code, data: &data)
        }
}
