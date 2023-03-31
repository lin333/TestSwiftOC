//
//  TBARBR.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBARBR: NSObject, TBCalculable {
    let code: String = "AR:SUM(HIGH-OPEN,M1)/SUM(OPEN-LOW,M1)*100;\n" +
    "BR:SUM(MAX(0,HIGH-REF(CLOSE,1)),M1)/SUM(MAX(0,REF(CLOSE,1)-LOW),M1)*100;"
    
    
    
    func calculate( data: inout [String : Entry]) -> [TBResultEntry] {
//        let params = TBStockTechParams.indicatorValues(forKey: "ARBR")
//        let dic = params[0]
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "ARBR"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
