//
//  TBMIKE.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBMIKE: NSObject, TBCalculable {
    let code: String = "HLC:=REF(MA((HIGH+LOW+CLOSE)/3,N),1);HV:=EMA(HHV(HIGH,N),3);LV:=EMA(LLV(LOW,N),3);STOR:EMA(2*HV-LV,3);MIDR:EMA(HLC+HV-LV,3);WEKR:EMA(HLC*2-LV,3);WEKS:EMA(HLC*2-HV,3);MIDS:EMA(HLC-HV+LV,3);STOS:EMA(2*LV-HV,3);"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "MIKE"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
