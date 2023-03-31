//
//  TBVR.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBVR: NSObject, TBCalculable {
    let code: String = "LC:=REF(CLOSE,1);\n" + "VR:SUM(IF(CLOSE>LC,VOL,0),M1)/SUM(IF(CLOSE<=LC,VOL,0),M1)*100;"
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["M1"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "VR"))
        return TBCalcUtils.run(code: code, data: &data)
        
    }
    
}
