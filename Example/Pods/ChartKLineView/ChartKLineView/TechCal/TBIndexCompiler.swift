//
//  TBIndexCompiler.swift
//  Stock
//
//  Created by Pengfei_Luo on 2016/12/7.
//  Copyright © 2016年 com.tigerbrokers. All rights reserved.
//

import UIKit

class TBIndexCompiler: NSObject {
    private var _tokenIndex: Int = 0
    private var _stmts: [TBStmtNode] = [TBStmtNode]()
    private var _tokens: [TBToken]?
    
    public init(tokens: [TBToken]) {
        super.init()
        _tokens = tokens
    }
    
    private func checkToken(_ type: TBTokenType) {
        if lookAHead_Kind(move: 0) == type {
            _tokenIndex++
        }
    }
    
    private func lookAHead_Kind(move: Int) -> TBTokenType? {
        if (_tokenIndex + move > (_tokens?.count)!) {
            return nil
        }
        var move = move
        
        var kind: TBTokenType = _tokens![_tokenIndex + move].kind
        while (kind == .SPACE) {
            kind = _tokens![_tokenIndex + ++move].kind
        }
        return kind
    }
    
    private func lookAHead_Image(move: Int) -> String? {
        if (_tokenIndex + move >= (_tokens?.count)!) {
            return ""
        }
        return _tokens![_tokenIndex + move].image
    }
    
    public func buildAST() -> [TBStmtNode] {
        while (_tokenIndex < (_tokens?.count)!) {
            let st: TBStmtNode = stmt()
            _stmts.append(st)
        }
        return _stmts
    }
    
    private func stmt() -> TBStmtNode {
        let exprStmtNode: TBExprStmtNode = TBExprStmtNode(e: getExpr())
        while (lookAHead_Kind(move: 0) == TBTokenType.COM) {
            popNextToken()
            exprStmtNode.addDecorate(decorate: popNextToken().image!)
        }
        checkToken( .COLON)
        return exprStmtNode
    }
    
    
    var lookaheadIndex: IntStack = IntStack()
    
    private func lookAHead_start() {
        lookaheadIndex.push(item: _tokenIndex)
    }
    
    private func lookAHead_end() {
        _tokenIndex = lookaheadIndex.pop()
    }
    
    @discardableResult private func popNextToken() -> TBToken{
        let token: TBToken = _tokens![_tokenIndex++]
        return token
    }
    
    private func peekNextToken() -> TBToken {
        let token: TBToken = _tokens![_tokenIndex]
        return token
    }
    
    private func getExpr() -> TBExproNode {
        var lhs: TBExproNode?
        var rhs: TBExproNode?
        var op: String
        
        lookAHead_start()
        
        term();
        let OP: String = popNextToken().image!;
        if (":=" == OP || ":" == OP) {
            lookAHead_end();
            lhs = term();
            op = popNextToken().image!;
            rhs = getExpr();
            if (":=" == OP) {
                return TBNewAssignNode(lhs!,  rhs!)
            } else if (lhs is TBVarNode && (rhs is TBNumberNode || rhs is TBVarNode)) {
                let name = (lhs as! TBVarNode).name
                for char in name! {
                    if char.isUppercase {
                        return TBAssignNode( lhs!,  rhs!)
                    }
                }
                
                return TBBrokenLineNode(rhs!,  lhs! as! TBVarNode)
            }
            return TBAssignNode( lhs!,  rhs!)
        }
        
        lookAHead_end()
        return getExpr9();
    }
    
    private func getExpr9() -> TBExproNode {
        var l: TBExproNode = getExpr8()
        var r: TBExproNode
        
        while ("OR" == lookAHead_Image(move: 0)) {
            popNextToken()
            r = getExpr8()
            l = TBLogicOrNode(l, r)
        }
        return l
    }
    
    private func getExpr8() -> TBExproNode {
        var l: TBExproNode = getExpr7()
        var r: TBExproNode
        
        while ("AND" == lookAHead_Image(move: 0)) {
            popNextToken()
            r = getExpr7()
            l = TBLogicAndNode(l, r)
        }
        
        return l
    }
    
    private func getExpr7() -> TBExproNode {
        var l: TBExproNode = getExpr6()
        var r: TBExproNode
        
        var op: String = lookAHead_Image(move: 0)!
        while (">" == op || "<" == op || ">=" == op || "<=" == op || "==" == op || "!=" == op)  {
            popNextToken()
            r = getExpr6()
            l = TBBinaryOpNode(l, r, op)
            op = lookAHead_Image(move: 0)!
        }
        return l
        
    }
    
    private func getExpr6() -> TBExproNode {
        var l: TBExproNode
        var r: TBExproNode
        l = getExpr5()
        var op: String = lookAHead_Image(move: 0)!
        while ("+" == op || "-" == op) {
            popNextToken()
            r = getExpr5()
            l = TBBinaryOpNode(l, r, op)
            op = lookAHead_Image(move: 0)!
        }
        
        return l
        
    }
    
    private func getExpr5() -> TBExproNode {
        var l: TBExproNode?
        var r: TBExproNode?
        l = term()
        var op: String = lookAHead_Image(move: 0)!
        while ("*" == op || "/" == op || "%" == op) {
            popNextToken()
            r = term()!
            l = TBBinaryOpNode(l!, r!, op)
            op = lookAHead_Image(move: 0)!
        }
        return l!
    }
    
    
    public func resetTokens(tokens: [TBToken]) {
        _tokenIndex = 0
        _stmts = [TBStmtNode]()
        _tokens = tokens
    }
    
    @discardableResult private func term() -> TBExproNode? {
        
        var token = _tokens![_tokenIndex++]
        while (token.kind == .RP || token.kind == .COM || token.kind == .COLON) {
            token = _tokens![++_tokenIndex]
        }
        var res: TBExproNode? = nil
        switch (token.kind) {
        case .AVEDEV:
            checkToken(.LP)
            let t11 = getExpr()
            checkToken(.COM)
            let t12 = getExpr()
            checkToken(.RP)
            return  TBAVDEVNode(t11, t12)
        case .SMA:
            checkToken(.LP)
            let t1 = getExpr()
            checkToken(.COM)
            let t21 = getExpr()
            checkToken(.COM)
            let smaNode = TBSMANode( t1,  t21,  getExpr())
            checkToken(.RP)
            return smaNode
        case .SUM:
            checkToken(.LP)
            let t4 = getExpr()
            checkToken(.COM)
            let t4s = getExpr()
            let sumNode = TBSUMNode( t4,  t4s)
            checkToken(.RP)
            return sumNode
        case .MA:
            checkToken(.LP)
            let t5 = getExpr()
            checkToken(.COM)
            let t6 = getExpr()
            checkToken(.RP)
            return TBMANode( t5,  t6)
        case .EMA:
            checkToken(.LP)
            let t8 = getExpr()
            checkToken(.COM)
            let emaNode = TBEMANode( t8,  getExpr())
            checkToken(.RP)
            return emaNode
        case .MAX:
            checkToken(.LP)
            let t2 = getExpr()
            checkToken(.COM)
            let maxNode = TBMAXNode( t2,  getExpr())
            checkToken(.RP)
            return maxNode
        case .MIN:
            checkToken(.LP)
            let t2 = getExpr()
            checkToken(.COM)
            let minNode = TBMINNode( t2,  getExpr())
            checkToken(.RP)
            return minNode
        case .IF:
            checkToken(.LP)
            let expr = getExpr()
            if (peekNextToken().kind == .COM) {
                popNextToken()
                let v1 = getExpr()
                checkToken(.COM)
                let ifNode = TBIFNode(expr , v1, getExpr())
                checkToken(.RP)
                return ifNode
            } else if (peekNextToken().kind == .RP) {
                popNextToken()
                var stmtNodes: [TBStmtNode] = [TBStmtNode]()
                while (peekNextToken().kind == .TAB) {
                    popNextToken()
                    stmtNodes.append(stmt())
                }
                return TBIFSTMTNode( expr, stmtNodes)
            }
            break
        case .ABS:
            checkToken(.LP)
            let absNode = TBABSNode( getExpr())
            checkToken(
                .RP)
            return absNode
        case .HIGH: fallthrough
        case .LOW: fallthrough
        case .CLOSE: fallthrough
        case .OPEN: fallthrough
        case .VOL:
            res = TBVALNode(token.kind)
            break
        case .REF:
            checkToken(.LP)
            let expr1 = getExpr()
            checkToken(.COM)
            let node = TBREFNode( expr1, getExpr())
            checkToken(.RP)
            return node
        case .DMA:
            checkToken(.LP)
            let t10 = getExpr()
            checkToken(.COM)
            let dmaNode = TBDMANode(t10, getExpr())
            checkToken(.RP)
            return dmaNode
        case .NUMBER:
            return TBNumberNode((token.image?.toDouble())!)
        case .VAR:
            return TBVarNode(token.image!)
        case .LP:
            let node1 = getExpr()
            checkToken(.RP)
            return node1
        case .OP:
            let node2 = getExpr()
            return TBUnaryOpNode(token.image!,  node2)
        case .HHV:
            checkToken(.LP)
            let node3 = getExpr()
            checkToken(.COM)
            let node4 = getExpr()
            checkToken(.RP)
            return TBHHVNode( node3,  node4)
        case .LLV:
            checkToken(.LP)
            let node6 = getExpr()
            checkToken(.COM)
            let node7 = getExpr()
            checkToken(.RP)
            return TBLLVNode( node6,  node7)
        case .STD:
            checkToken(.LP)
            let node8 = getExpr()
            checkToken(.COM)
            let node9 = getExpr()
            checkToken(.RP)
            return TBSTDNode( node8,  node9)
        case .SAR:
            checkToken(.LP)
            let node10 = getExpr()
            checkToken(.COM)
            let node11 = getExpr()
            checkToken(.COM)
            let node12 = getExpr()
            checkToken(.RP)
            return TBSARNode( node10,  node11, node12)
        case .ZigZag:
            checkToken(.LP)
            let node10 = getExpr()
            checkToken(.COM)
            let node11 = getExpr()
            checkToken(.COM)
            let node12 = getExpr()
            checkToken(.RP)
            return TBZigZagNode( node10,  node11, node12)
        default:
            break
        }
        return res
    }
}
