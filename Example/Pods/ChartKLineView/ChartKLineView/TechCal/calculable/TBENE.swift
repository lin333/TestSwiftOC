//
//  TBENE.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBENE: NSObject, TBCalculable {
    let code: String = "UPPER:(1+M1/100)*MA(CLOSE,N);LOWER:(1-M2/100)*MA(CLOSE,N);ENE:(UPPER+LOWER)/2;"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "ENE"))
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "ENE"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "ENE"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
