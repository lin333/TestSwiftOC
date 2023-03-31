//
//  TBBBIBOLL.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBBBIBOLL: NSObject, TBCalculable {
    let code: String = "CV:=CLOSE;BBIBOLL:(MA(CV,3)+MA(CV,6)+MA(CV,12)+MA(CV,24))/4;UPR:BBIBOLL+M*STD(BBIBOLL,N);DWN:BBIBOLL-M*STD(BBIBOLL,N);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "BBIBOLL"))
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "BBIBOLL"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
