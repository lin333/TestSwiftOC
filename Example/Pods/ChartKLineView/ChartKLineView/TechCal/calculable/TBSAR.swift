//
//  TBSAR.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBSAR: NSObject, TBCalculable {
    let code: String = "SAR1:SAR(N,MAXAF,MINAF),CIRCLEDOT;"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "SAR"))
        data["MINAF"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "SAR"))
        data["MAXAF"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "SAR"))
        
        return TBCalcUtils.run(code: code, data: &data)
    }
}
