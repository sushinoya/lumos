//
//  LMMethod.swift
//  Lumos
//
//  Created by Suyash Shekhar on 20/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public struct LMMethod {
    
    public let name: String
    public let method: Method
    public let selector: Selector
    public let implementation: IMP
    public let encoding: String?
    public let returnType: String
    public let argumentTypes: [String]
    public let numberOfArguments: Int
    
    init(method: Method) {
        let selector = method_getName(method)
        
        self.name = String(cString: sel_getName(selector))
        self.method = method
        self.selector = selector
        self.implementation = method_getImplementation(method)
        self.returnType = String(cString: method_copyReturnType(method))
        self.argumentTypes = LMMethod.getArgumentTypes(method: method)
        self.numberOfArguments = Int(method_getNumberOfArguments(method))
        
        if let encoding = method_getTypeEncoding(method) {
            self.encoding = String(cString: encoding)
        } else {
            self.encoding = nil
        }
        
    }
    
}

extension LMMethod {
    private func getMethodName(selector: Selector) -> String {
        return String(cString: sel_getName(selector))
    }
    
    private static func getArgumentTypes(method: Method) -> [String] {
        var arguments = [String]()
        var index: UInt32 = 0
        var argumentType = method_copyArgumentType(method, index)
        
        while argumentType != nil {
            guard let arg = argumentType else { continue }
            arguments.append(String(cString: arg))
            arg.deallocate()
            index += 1
            argumentType = method_copyArgumentType(method, index)
        }
        return arguments
    }
}
