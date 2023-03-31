//
//  TBParser.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/11/20.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBParser: NSObject {
    open var column: Int = Int(0)
    open var line: Int = Int(0)
    
    open var code: String = ""
    
    public let keyWords:[String: TBTokenType] = [
         "SMA" : .SMA, 
         ":=" : .NEW_ASSIGN, 
         "HIGH" : .HIGH, 
         "LOW" : .LOW,
         "OPEN" : .OPEN,
         "CLOSE" : .CLOSE,
         "REF" : .REF,
         "ABS" : .ABS,
         "IF" : .IF,
         "MAX" : .MAX,
         "MIN" : .MIN,
         "AND" : .AND,
         "OR" : .OR,
         "SUM" : .SUM,
         "MA" : .MA,
         "EMA" : .EMA,
         "VOL" : .VOL,
         "COLORSTICK" : .COLORSTICK,
         "CIRCLEDOT" : .CIRCLEDOT,
         "HHV" : .HHV,
         "LLV" : .LLV,
         "STD" : .STD,
         "SAR" : .SAR,
         "AVEDEV":.AVEDEV,
         "DMA": .DMA,
         "ZigZag": .ZigZag,
    ]
    
    
    public init(code: String) {
        super.init()
        self.code = code
    }
    
//    public static func main() {
//        let parser = TBParser(code: "")
//        let tokens = parser.getTokens()
//        let compiler = TBIndexCompiler(tokens: tokens)
//        let node = compiler.buildAST()
////        for stmtNode in node {
////            print("\(stmtNode)")
////        }
////        print("completed")
//    
//    }
    
    public func getTokens() -> [TBToken] {
        var res: [TBToken] = [TBToken]()
        var nextToken = getNextToken()
        while nextToken != nil {
            res.append(nextToken!)
            nextToken = getNextToken()
        }
        return res
        
    }
    
    public func resetCode(code: String) {
        self.column = Int(0)
        self.line = Int(0)
        self.code = code
    }
    
    private func getNextToken() -> TBToken? {
        
        while true {
            guard !code.isEmpty else {
                return nil
            }
            guard column < code.count else {
                return nil
            }
            
            var c = code.charAt(index:column)
            switch c {
            case " ":
                column++
                continue
            case "\t":
                column++
                return TBToken(initKind: .TAB, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case "\n":
                column++
                line++
                continue
            case "(":
                column++
                return TBToken(initKind: .LP, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case ")":
                column++
                return TBToken(initKind:.RP, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case "<":
                if (code.charAt(index: column + 1) == "=") {
                    column += 2
                    return TBToken(initKind:.LTE,  initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: "<=", initNext: nil, initSpecialToken: nil)
                }
                column++
                return TBToken(initKind:.LT, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case ">":
                if (code.charAt(index: column + 1) == "=") {
                    column += 2
                    return TBToken(initKind:.GTE,  initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ">=", initNext: nil, initSpecialToken: nil)
                }
                column++
                return TBToken(initKind:.GT, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case ";":
                column++
                return TBToken(initKind:.COLON, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case "=":
                if (code.charAt(index: column + 1) == "=") {
                    column += 2
                    return TBToken(initKind:.EQ,  initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: "==", initNext: nil, initSpecialToken: nil)
                }
                column++
                return TBToken(initKind:.EQ, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case ":":
                if (code.charAt(index: column + 1) == "=") {
                    column += 2
                    return TBToken(initKind:.NEW_ASSIGN,  initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ":=", initNext: nil, initSpecialToken: nil)
                }
                column++
                return TBToken(initKind:.ASSIGN, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case "+":fallthrough
            case "-":fallthrough
            case "*":fallthrough
            case "/":
                column++
                return TBToken(initKind:.OP, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            case ",":
                column++
                return TBToken(initKind:.COM, initBeginLine: line, initEndLine: line, initBeginColumn: column, initEndColumn: column + 1, initImage: ("\(c)" + ""), initNext: nil, initSpecialToken: nil)
            default:
                break
                
            }
            var res = String()
            while (c.isLetter || (res.count > 0 && c.isLetterOrDigit())) {
                res += "\(c)"
                if (column > (code.count - 1)) {
                    break
                }
                c = code.charAt(index: (++column))
            }
            
            if res.count != 0 {
                
                if keyWords.keys.contains(res) {
                    return TBToken(initKind:keyWords[res]!, initBeginLine: line, initEndLine: line, initBeginColumn: column - res.count, initEndColumn: column, initImage: res, initNext: nil, initSpecialToken: nil)
                } else {
                    return TBToken(initKind:.VAR, initBeginLine: line, initEndLine: line, initBeginColumn: column - res.count, initEndColumn: column, initImage: res, initNext: nil, initSpecialToken: nil)
                }
                
            }
            
            while c.isNumber || c == "." {
                res += "\(c)"
                if column >= code.count - 1 {
                    column++
                    break
                }
                c = code.charAt(index: (++column))
            }
            
            return TBToken(initKind:.NUMBER, initBeginLine: line, initEndLine: line, initBeginColumn: column - res.count, initEndColumn: column, initImage: res, initNext: nil, initSpecialToken: nil)
        }
    }
    
}
