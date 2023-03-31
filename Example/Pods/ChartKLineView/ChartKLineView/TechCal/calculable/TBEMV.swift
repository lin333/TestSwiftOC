//
//  TBEMV.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBEMV:  NSObject, TBCalculable {
    let code: String = "VOLUME:=MA(VOL,N)/VOL; \n" +
        "MID:=100*(HIGH+LOW-REF(HIGH+LOW,1))/(HIGH+LOW); \n" +
        "TEMP:= MID*VOLUME*(HIGH-LOW); \n" +
        "IF (HIGH == LOW) \n" +
        "\tTEMP:=0;\n" +
        "EMV:MA(TEMP/MA(HIGH-LOW,N),N); \n" +
    "MAEMV:MA(EMV,M);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "EMV"))
        data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 1, key: "EMV"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
