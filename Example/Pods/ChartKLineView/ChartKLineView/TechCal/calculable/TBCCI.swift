//
//  TBCCI.swift
//  Stock
//
//  Created by luopengfei on 2018/4/26.
//  Copyright © 2018年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBCCI: NSObject, TBCalculable {
    let code: String = "TYP:=(HIGH+LOW+CLOSE)/3;\n" +
    "CCI:(TYP-MA(TYP,N))/(0.015*AVEDEV(TYP,N));"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "CCI"))
        
        return TBCalcUtils.run(code: code, data: &data)
    }
    
}
