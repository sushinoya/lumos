//
//  LumosClass.swift
//  Lumos
//
//  Created by Suyash Shekhar on 16/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

class LMClass {
    
    // MARK: Tests

    // func class_isMetaClass(AnyClass?) -> Bool
    static func isMetaClass(_ _class: AnyClass) -> Bool {
        return class_isMetaClass(_class)
    }
    
    
    //  func class_respondsToSelector(AnyClass?, Selector) -> Bool
    
    
    //  func class_conformsToProtocol(AnyClass?, Protocol?) -> Bool
    static func conformsToProtocol(_ _class: AnyClass, _protocol: Protocol) -> Bool {
        return class_conformsToProtocol(_class, _protocol)
    }
    
    
    // MARK: Getter Functions
    
    // func class_getName(AnyClass?) -> UnsafePointer<Int8>
    static func getName(of _class: AnyClass) -> String? {
        let className = String(cString: class_getName(_class))
        guard className.count > 0 else { return nil }
        return className
    }

    
    // func class_getSuperclass(AnyClass?) -> AnyClass?
    static func getSuperclass(of _class: AnyClass) -> AnyClass? {
        return class_getSuperclass(_class)
    }
    
    
    // func class_getInstanceSize(AnyClass?) -> Int
    static func getInstanceSize(of _class: AnyClass) -> Int {
        return class_getInstanceSize(_class)
    }
    
    
    // func class_getInstanceVariable(AnyClass?, UnsafePointer<Int8>) -> Ivar?
    static func getInstanceVariable(from _class: AnyClass, withName name: String) -> LMVariable? {
        guard let ivar = class_getInstanceVariable(_class, name) else { return nil }
        return LMVariable(ivar: ivar)
    }
    
    
    // func class_getClassVariable(AnyClass?, UnsafePointer<Int8>) -> Ivar?
    static func getClassVariable(from _class: AnyClass, withName name: String) -> LMVariable? {
        guard let ivar = class_getClassVariable(_class, name) else { return nil }
        return LMVariable(ivar: ivar)
    }
    
    
    // func class_copyIvarList(AnyClass?, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Ivar>?
    static func getVariablesList(from _class: AnyClass) -> [LMVariable] {
        return [LMVariable]()
    }
    
    
    // func class_getIvarLayout(AnyClass?) -> UnsafePointer<UInt8>?
    static func getStrongVariablesLayout(for _class: AnyClass) -> String? {
        guard let layout = class_getIvarLayout(_class) else { return nil }
        return String(cString: layout)
    }
    
    
    // func class_getWeakIvarLayout(AnyClass?) -> UnsafePointer<UInt8>?
    static func getWeakVariablesLayout(for _class: AnyClass) -> String? {
        guard let layout = class_getWeakIvarLayout(_class) else { return nil }
        return String(cString: layout)
    }
    
    
    // func class_getProperty(AnyClass?, UnsafePointer<Int8>) -> objc_property_t?
    static func getProperty(for _class: AnyClass, propertyName: String) -> LMProperty? {
        guard let propertyPointer = class_getProperty(_class, propertyName) else { return nil }
        return LMProperty(propertyPointer: propertyPointer)
    }
    
    // func class_copyPropertyList(AnyClass?, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_property_t>?
    
    //    func class_getInstanceMethod(AnyClass?, Selector) -> Method?

    //    func class_getClassMethod(AnyClass?, Selector) -> Method?
    
    //    func class_copyMethodList(AnyClass?, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Method>?
    
    //    func class_getMethodImplementation(AnyClass?, Selector) -> IMP?

    //    func class_getMethodImplementation_stret(AnyClass?, Selector) -> IMP?

    //    func class_copyProtocolList(AnyClass?, UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?
    
    // MARK: Modifiers
    
// Depreciated: func class_setSuperclass(AnyClass, AnyClass) -> AnyClass
//    func class_addIvar(AnyClass?, UnsafePointer<Int8>, Int, UInt8, UnsafePointer<Int8>?) -> Bool
//    func class_setIvarLayout(AnyClass?, UnsafePointer<UInt8>?)
//    func class_setWeakIvarLayout(AnyClass?, UnsafePointer<UInt8>?)
//    func class_addMethod(AnyClass?, Selector, IMP, UnsafePointer<Int8>?) -> Bool
//    func class_replaceMethod(AnyClass?, Selector, IMP, UnsafePointer<Int8>?) -> IMP?
//    func class_addProtocol(AnyClass?, Protocol) -> Bool
//    func class_addProperty(AnyClass?, UnsafePointer<Int8>, UnsafePointer<objc_property_attribute_t>?, UInt32) -> Bool
//    func class_replaceProperty(AnyClass?, UnsafePointer<Int8>, UnsafePointer<objc_property_attribute_t>?, UInt32)
//    func class_getVersion(AnyClass?) -> Int32
//    func class_setVersion(AnyClass?, Int32)
//    Sets the version number of a class definition.
}
