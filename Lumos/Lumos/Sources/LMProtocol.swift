//
//  LMProtocol.swift
//  Lumos
//
//  Created by Suyash Shekhar on 19/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public struct LMProtocol {
    
    let proto: Protocol
    let name: String
    
    init(proto: Protocol) {
        self.proto = proto
        self.name = String(cString: protocol_getName(proto))
    }
    
    // func objc_getProtocol(UnsafePointer<Int8>) -> Protocol?
    init?(withName name: String) {
        let namePointer = name.toPointer()
        defer { namePointer.deallocate() }
        
        if let proto = objc_getProtocol(namePointer) {
            self.init(proto: proto)
        } else {
            return nil
        }
    }
    
    // func objc_copyProtocolList(UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?
    // func objc_allocateProtocol(UnsafePointer<Int8>) -> Protocol?
    // func objc_registerProtocol(Protocol)
    // func protocol_addMethodDescription(Protocol, Selector, UnsafePointer<Int8>?, Bool, Bool)
    // func protocol_addProtocol(Protocol, Protocol)
    // func protocol_addProperty(Protocol, UnsafePointer<Int8>, UnsafePointer<objc_property_attribute_t>?, UInt32, Bool, Bool)
    // func protocol_isEqual(Protocol?, Protocol?) -> Bool
    // func protocol_copyMethodDescriptionList(Protocol, Bool, Bool, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_method_description>?
    // func protocol_getMethodDescription(Protocol, Selector, Bool, Bool) -> objc_method_description
    // func protocol_copyPropertyList(Protocol, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_property_t>?
    // func protocol_getProperty(Protocol, UnsafePointer<Int8>, Bool, Bool) -> objc_property_t?
    // func protocol_copyProtocolList(Protocol, UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?
    // func protocol_conformsToProtocol(Protocol?, Protocol?) -> Bool

}
