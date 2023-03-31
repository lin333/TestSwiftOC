//
//  TBJAX.swift
//  TBMixedChartView
//
//  Created by 骆鹏飞 on 2019/12/2.
//  Copyright © 2019 luopengfei. All rights reserved.
//

import UIKit

class TBJAX: NSObject, TBCalculable {
    let code: String = "AA:=ABS((2*CLOSE+HIGH+LOW)/4-MA(CLOSE,N))/MA(CLOSE,N);\n" +
    "济安线:DMA((2*CLOSE+LOW+HIGH)/4,AA),LINETHICK3,COLORMAGENTA;\n" + "CC:=(CLOSE/济安线);\n" +
    "MA1:=MA(CC*(2*CLOSE+HIGH+LOW)/4,3);\n" + "MAAA:=((MA1-济安线)/济安线)/3;\n" + "TMP:=MA1-MAAA*MA1;\n" +
    "J:IF(TMP<=济安线,济安线,DRAWNULL),LINETHICK3,COLORCYAN;\n" + "A:TMP,LINETHICK2,COLORYELLOW;\n" +
    "X:IF(TMP<=济安线,TMP,DRAWNULL),LINETHICK2,COLORGREEN;"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        data["N"] = TBParamEntry(value: TBStockTechParams.paramsCurrentValue(index: 0, key: "JAX"))
        return TBCalcUtils.run(code: code, data: &data)
    }
}
