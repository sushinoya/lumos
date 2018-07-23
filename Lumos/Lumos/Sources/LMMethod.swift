//
//  LMMethod.swift
//  Lumos
//
//  Created by Suyash Shekhar on 20/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation
import Aspects

public struct LMMethod {
    
    public let name: String
    public let `class`: AnyClass
    public let type: MethodType
    public let methodPointer: Method
    public let selector: Selector
    public let implementation: IMP
    public let encoding: String?
    public let returnType: String
    public let argumentTypes: [String]
    public let numberOfArguments: Int
    
    init(method: Method, class: AnyClass) {
        let selector = method_getName(method)
        
        self.name = String(cString: sel_getName(selector))
        self.class = `class`
        self.methodPointer = method
        self.selector = selector
        self.implementation = method_getImplementation(method)
        self.returnType = Util.valueForType(type: String(cString: method_copyReturnType(method)))
        self.argumentTypes = LMMethod.getArgumentTypes(method: method)
        self.numberOfArguments = Int(method_getNumberOfArguments(method))
        
        if let encoding = method_getTypeEncoding(method) {
            self.encoding = String(cString: encoding)
        } else {
            self.encoding = nil
        }
        
        let respondsToInstanceMethod = class_getInstanceMethod(self.class, selector) == method
        let respondsToClassMethod = class_getClassMethod(self.class, selector) == method

        assert(respondsToInstanceMethod || respondsToClassMethod)
        
        if respondsToInstanceMethod {
            self.type = .instance
        } else {
            self.type = .class
        }
        
    }
}

public enum MethodType {
    case instance
    case `class`
}

// MARK: Swizzling and Aspect Methods
extension LMMethod {
    public func swapImplementation(with method: Method) {
        method_exchangeImplementations(self.methodPointer, method)
        
    }
    
    public func swapImplementation(with lmMethod: LMMethod) {
        method_exchangeImplementations(self.methodPointer, lmMethod.methodPointer)
    }
    
    public func append(block: @escaping () -> Void) {
        hook(option: .optionAutomaticRemoval, errorMessage: LMMethod.errorMessage(.cannotAppend), block: block)
    }
    
    public func prepend(block: @escaping () -> Void) {
        hook(option: .positionBefore, errorMessage: LMMethod.errorMessage(.cannotPrepend), block: block)
    }
    
    public func replace(block: @escaping () -> Void) {
        // Check if the method signature is () -> Void
        guard self.returnType == "v" && self.argumentTypes == ["@", ":"] else {
            print(LMMethod.errorMessage(.invalidMethodSignature))
            return
        }

        hook(option: .positionInstead, errorMessage: LMMethod.errorMessage(.cannotReplace), block: block)
    }
    
    private func hook(option: AspectOptions, errorMessage: String, block: @escaping () -> Void) {
        guard Lumos.for(self.class).getClassHierarchy().last == NSObject.self else {
            print(LMMethod.errorMessage(.notNSObjectSubclass))
            return
        }
        
        guard Lumos.for(self.class).getInstanceMethod(selector: self.selector) != nil else {
            print(LMMethod.errorMessage(.nonInstanceMethod))
            return
        }
        
        typealias BlockType = () -> Void
        
        let closure:(() -> Void) = {  block() }
        let block: @convention(block) () -> Void = closure
        do {
            _ = try self.class.aspect_hook(self.selector, with: option, usingBlock: unsafeBitCast(block, to: AnyObject.self))
        } catch  {
            print(errorMessage)
        }
    }
}


// MARK: Util
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
            arguments.append(Util.valueForType(type: String(cString: arg)))
            arg.deallocate()
            index += 1
            argumentType = method_copyArgumentType(method, index)
        }
        return arguments
    }
    
    
    private static func errorMessage(_ type: ErrorMessage) -> String {
        return "Lumos: \(type.rawValue) Aborting Operation..."
    }
}

extension LMMethod {
    enum ErrorMessage: String {
        case invalidMethodSignature = "Can only replace methods of type () -> Void. For other type signatures, use explicit method swizzling."
        case cannotAppend = "Unable to append block to method."
        case cannotPrepend = "Unable to prepend block to method."
        case cannotReplace = "Unable to replace block to method. Make sure the type signatures of the block and the method are the same."
        case nonInstanceMethod = "Can append/prepend/replace only instance methods."
        case notNSObjectSubclass = "Cannot append/prepend/replace methods from classes which do not subclass NSObject."
    }
}


