//
//  TBOBV.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/8.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBOBV: NSObject, TBCalculable {
    let code: String = "OBV:SUM(IF(CLOSE>REF(CLOSE,1),VOL,IF(CLOSE<REF(CLOSE,1),-VOL,0)),0)/10000;"
    
    func calculate(data: inout [String : Entry]) -> [TBResultEntry] {
        
        
        return TBCalcUtils.run(code: code, data: &data)
    }
}
