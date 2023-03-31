//
//  TBCalcUtils.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/7.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBCalcUtils: NSObject {
    
    /// static and class both associate a method with a class, rather than an instance of a class. The difference is that subclasses can override class methods; they cannot override static methods
   /// class properties will theoretically function in the same way (subclasses can override them), but they're not possible in Swift yet
        
    private static let parser: TBParser = TBParser(code: "")
    private static let compiler: TBIndexCompiler = TBIndexCompiler(tokens: [TBToken]())
    
    public static func run(code: String, data: inout [String: Entry]) -> [TBResultEntry] {
        var code = code
        code = preprocessor(code: &code, data: data)
        
        parser.resetCode(code: code)
        let  tokens: [TBToken] = parser.getTokens()

        compiler.resetTokens(tokens: tokens)
        let node: [TBStmtNode] = compiler.buildAST()
        for stmtNode in node {
            _ = stmtNode.evalE(data: &data)
        }
        
        var result: [TBResultEntry] = [TBResultEntry]()
        let tmpResult = data.filter { (_, v) -> Bool in
            return v.isResult
        }
        
        for (_, v) in tmpResult.enumerated() {
            let value: Entry = v.value

            let tmpDouble: [Double] = value.getEntry() as! [Double]
            
            result.append(TBResultEntry(name: v.key, object: tmpDouble, decorations: value.decorations))
        }
        return result
    }
    
    
    private static func preprocessor(code: inout String, data: [String: Entry]) -> String {
        var params: [Entry] = [Entry]()
        let keys = data.keys.sorted()
        
        for key in keys {
            let tmpValue: Entry = data[key]!
            if (tmpValue.isConstant()) {
                params.append(tmpValue)
            }
        }
        
        while (code.contains("$")) {
            let codens: NSString = code as NSString
            let location: NSRange = codens.range(of: "$")
            let loc: Int = location.location
            let locChar: Character = code.charAt(index: loc + 1)
            
            if (loc != -1 && loc != (code.count - 1) && locChar.isNumber) {
                let tmpChar: Character = code.charAt(index: loc + 1)
                let zeroChar: Character = "0"
                
                let val: Int = tmpChar.asciiValue - zeroChar.asciiValue
                
                let replaceStr: String = "\(params[val - 1].getEntry())"
                
                code = code.replacingOccurrences(of: "$"+"\(val)", with:replaceStr  + "")
            }
            
        }
        return code
    }
    
}
