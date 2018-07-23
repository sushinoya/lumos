//
//  LumosMain.swift
//  Lumos
//
//  Created by Suyash Shekhar on 17/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public class Lumos {
    public static var swizzles = [SwizzleEntry]()
    
    
    public static func `for`(_ cls: AnyClass) -> LMClass { return LMClass(class: cls) }
    public static func `for`(_ obj: AnyObject) -> LMClass { return LMClass(class: type(of: obj)) }
    public static func `for`(_ protocol: Protocol) -> LMProtocol { return LMProtocol(protocol: `protocol`) }
    public static func `for`(_ ivar: Ivar) -> LMVariable? { return LMVariable(ivar: ivar) }
    
    public static func `for`(_ propertyAttribute: objc_property_attribute_t) -> LMPropertyAttribute {
        return LMPropertyAttribute(rawStruct: propertyAttribute)
    }
    
    public static func `for`(_ propertyPointer: objc_property_t) -> LMProperty {
        return LMProperty(propertyPointer: propertyPointer)
    }
}

public extension NSObject {
    public var lumos: LMClass { return LMClass(object: self) }
}

public extension objc_property_attribute_t {
    public var lumos: LMPropertyAttribute { return LMPropertyAttribute(rawStruct: self) }
}

