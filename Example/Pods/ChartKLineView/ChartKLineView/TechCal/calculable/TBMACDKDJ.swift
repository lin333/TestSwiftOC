//
//  TBMACDKDJ.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBMACDKDJ: NSObject, TBCalculable {
    let code: String = "DIF:(EMA(CLOSE,N1)-EMA(CLOSE,N2))*100;\n" +
        "DEA:EMA(DIF,N3);\n" +
        "MACD:(DIF-DEA),COLORSTICK;" + "RSV:=(CLOSE-LLV(LOW,N))/(HHV(HIGH,N)-LLV(LOW,N))*100;\n" +
        "K:SMA(RSV,M1,1);\n" +
        "D:SMA(K,M2,1);\n" +
    "J:3*K-2*D;"
    
    public func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        //// 待完善
        data["N1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "MACD"))
        data["N2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "MACD"))
        data["N3"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "MACD"))
        
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "KDJ"))
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "KDJ"))
        data["M2"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 2, key: "KDJ"))
        
        return TBCalcUtils.run(code: code, data: &data)
        
    }
    
    
    
}
