//
//  TBBBI.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBBBI: NSObject, TBCalculable {
    
    let code: String = "BBI:(MA(CLOSE,M1)+MA(CLOSE,M2)+MA(CLOSE,M3)+MA(CLOSE,M4))/4;"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "BBI"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "BBI"))
        data["M3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "BBI"))
        data["M4"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "BBI"))

        return TBCalcUtils.run(code: code, data: &data)
    }
    

}
