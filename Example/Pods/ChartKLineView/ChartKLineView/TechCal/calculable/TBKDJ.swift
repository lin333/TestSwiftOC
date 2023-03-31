//
//  TBKDJ.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBKDJ:  NSObject, TBCalculable {
    let code: String =  "RSV:=(CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N))*100;\n" +
        "K:SMA(RSV,M1,1);\n" +
        "D:SMA(K,M2,1);\n" +
    "J:3*K-2*D;" +
        "a:M3;\n" + "b:M4;\n" + "c:M5;"
    
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "KDJ"))
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "KDJ"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "KDJ"))
        data["M3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 3, key: "KDJ"))
        data["M4"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 4, key: "KDJ"))
        data["M5"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 5, key: "KDJ"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
