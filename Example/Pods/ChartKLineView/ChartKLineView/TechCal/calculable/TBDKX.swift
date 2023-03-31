//
//  TBDKX.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/11/18.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBDKX: NSObject, TBCalculable {
    let code: String = "MID:=(3*CLOSE+LOW+OPEN+HIGH)/6;\n" + "DKX:(20*MID+19*REF(MID,1)+18*REF(MID,2)+17*REF(MID,3)+\n" +
    "16*REF(MID,4)+15*REF(MID,5)+14*REF(MID,6)+\n" + "13*REF(MID,7)+12*REF(MID,8)+11*REF(MID,9)+\n" +
    "10*REF(MID,10)+9*REF(MID,11)+8*REF(MID,12)+\n" + "7*REF(MID,13)+6*REF(MID,14)+5*REF(MID,15)+\n" +
    "4*REF(MID,16)+3*REF(MID,17)+2*REF(MID,18)+REF(MID,20))/210;\n" + "MADKX:MA(DKX,M);\n"
        
        func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
    //        let param: [Int] = <#value#>
            /// TODO: 指标范围添加
            data["M"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "DKX"))
            return TBCalcUtils.run(code: code, data: &data)
        }
}
