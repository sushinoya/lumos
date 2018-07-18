//
//  LumosClass.swift
//  Lumos
//
//  Created by Suyash Shekhar on 16/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public class LMClass {
    
    let classType: AnyClass
    
    public init(object: AnyObject) {
        self.classType = type(of: object)
    }
    
    public init(class _class: AnyClass) {
        self.classType = _class
    }
    
    // MARK: Boolean Checks
    
    // func class_isMetaClass(AnyClass?) -> Bool
    public func isMetaClass() -> Bool {
        return class_isMetaClass(self.classType)
    }
    
    
    //  func class_respondsToSelector(AnyClass?, Selector) -> Bool
    
    
    //  func class_conformsToProtocol(AnyClass?, Protocol?) -> Bool
    public func conformsToProtocol(_ _protocol: Protocol) -> Bool {
        return class_conformsToProtocol(self.classType, _protocol)
    }
    
    
    
    // MARK: Getter Functions
    
    // func class_getName(AnyClass?) -> UnsafePointer<Int8>
    public func getName() -> String? {
        let className = String(cString: class_getName(self.classType))
        guard className.count > 0 else { return nil }
        return className
    }
    
    
    // func class_getSuperclass(AnyClass?) -> AnyClass?
    public func getSuperclass() -> AnyClass? {
        return class_getSuperclass(self.classType)
    }
    
    
    // func class_getInstanceSize(AnyClass?) -> Int
    public func getInstanceSize() -> Int {
        return class_getInstanceSize(self.classType)
    }
    
    
    // func class_getInstanceVariable(AnyClass?, UnsafePointer<Int8>) -> Ivar?
    public func getInstanceVariable(withName name: String) -> LMVariable? {
        guard let ivar = class_getInstanceVariable(self.classType, name) else { return nil }
        return LMVariable(ivar: ivar)
    }
    
    
    // func class_getClassVariable(AnyClass?, UnsafePointer<Int8>) -> Ivar?
    public func getClassVariable(withName name: String) -> LMVariable? {
        guard let ivar = class_getClassVariable(self.classType, name) else { return nil }
        return LMVariable(ivar: ivar)
    }
    
    
    // func class_copyIvarList(AnyClass?, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Ivar>?
    public func getVariables() -> [LMVariable] {
        var variables = [LMVariable]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        guard let ivarList = class_copyIvarList(self.classType, count) else { return variables }
        
        for ivarCount in 0..<count.pointee {
            let ivar = ivarList[Int(ivarCount)]
            
            if let variable = LMVariable(ivar: ivar) {
                variables.append(variable)
            }
        }
        
        count.deallocate()
        return variables
    }
    
    
    // func class_getIvarLayout(AnyClass?) -> UnsafePointer<UInt8>?
    public func getStrongVariablesLayout() -> String? {
        guard let layout = class_getIvarLayout(self.classType) else { return nil }
        return String(cString: layout)
    }
    
    
    // func class_getWeakIvarLayout(AnyClass?) -> UnsafePointer<UInt8>?
    public func getWeakVariablesLayout() -> String? {
        guard let layout = class_getWeakIvarLayout(self.classType) else { return nil }
        return String(cString: layout)
    }
    
    
    // func class_getProperty(AnyClass?, UnsafePointer<Int8>) -> objc_property_t?
    public func getProperty(withName propertyName: String, completion: @escaping (LMProperty) -> ()) {
        propertyName.withCString { pointer -> () in
            guard let propertyPointer = class_getProperty(self.classType, pointer) else { return }
            let property = LMProperty(propertyPointer: propertyPointer)
            completion(property)
        }
    }
    
    
    public func getProperty(withName propertyName: String) -> LMProperty? {
        return self.getProperties().filter { $0.name == propertyName }.first
    }
    
    
    // func class_copyPropertyList(AnyClass?, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_property_t>?
    public func getProperties() -> [LMProperty] {
        var properties = [LMProperty]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        guard let propertyList = class_copyPropertyList(self.classType, count) else { return properties }
        
        for propertyCount in 0..<count.pointee {
            let property = propertyList[Int(propertyCount)]
            properties.append(LMProperty(propertyPointer: property))
        }
        
        propertyList.deallocate()
        count.deallocate()
        return properties
    }
    
    //    public func class_copyProtocolList(AnyClass?, UnsafeMutablePointer<UInt32>?) ->
    //    AutoreleasingUnsafeMutablePointer<Protocol>?
    public func getProtocols() -> [LMProtocol] {
        var protocols = [LMProtocol]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        guard let protocolList = class_copyProtocolList(self.classType, count) else {
            return protocols
        }
        
        for protocolCount in 0..<count.pointee {
            let proto = protocolList[Int(protocolCount)]
            protocols.append(LMProtocol(proto: proto))
        }
        
        count.deallocate()
        return protocols
    }
    
    //    public func class_getInstanceMethod(AnyClass?, Selector) -> Method?
    
    //    public func class_getClassMethod(AnyClass?, Selector) -> Method?
    
    //    public func class_copyMethodList(AnyClass?, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<Method>?
    
    //    public func class_getMethodImplementation(AnyClass?, Selector) -> IMP?
    
    //    public func class_getMethodImplementation_stret(AnyClass?, Selector) -> IMP?
    
    // MARK: Modifiers
    
    // Depreciated: func class_setSuperclass(AnyClass, AnyClass) -> AnyClass
    //    public func class_addIvar(AnyClass?, UnsafePointer<Int8>, Int, UInt8, UnsafePointer<Int8>?) -> Bool
    //    public func class_setIvarLayout(AnyClass?, UnsafePointer<UInt8>?)
    //    public func class_setWeakIvarLayout(AnyClass?, UnsafePointer<UInt8>?)
    //    public func class_addMethod(AnyClass?, Selector, IMP, UnsafePointer<Int8>?) -> Bool
    //    public func class_replaceMethod(AnyClass?, Selector, IMP, UnsafePointer<Int8>?) -> IMP?
    //    public func class_addProtocol(AnyClass?, Protocol) -> Bool
    //    public func class_addProperty(AnyClass?, UnsafePointer<Int8>, UnsafePointer<objc_property_attribute_t>?, UInt32) -> Bool
    //    public func class_replaceProperty(AnyClass?, UnsafePointer<Int8>, UnsafePointer<objc_property_attribute_t>?, UInt32)
    //    public func class_getVersion(AnyClass?) -> Int32
    //    public func class_setVersion(AnyClass?, Int32)
    //    Sets the version number of a class definition.
}
