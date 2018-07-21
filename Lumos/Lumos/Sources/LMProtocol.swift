//
//  LMProtocol.swift
//  Lumos
//
//  Created by Suyash Shekhar on 19/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public struct LMProtocol: Equatable {
    
    let `protocol`: Protocol
    let name: String
    
    init(protocol: Protocol) {
        self.protocol = `protocol`
        self.name = String(cString: protocol_getName(`protocol`))
    }
    
    /// Wrapper for: func objc_getProtocol(UnsafePointer<Int8>) -> Protocol?
    init?(withName name: String) {
        let namePointer = name.toPointer()
        defer { namePointer.deallocate() }
        
        if let proto = objc_getProtocol(namePointer) {
            self.init(protocol: proto)
        } else {
            return nil
        }
    }
    
    /// Wrapper for: func protocol_addProtocol(Protocol, Protocol).
    ///The protocol you want to add to (proto) must be under construction—allocated but not yet registered with the Objective-C runtime. The protocol you want to add (addition) must be registered already.
    func addConformanceTo(protocol: Protocol) {
        protocol_addProtocol(self.protocol, `protocol`)
    }

    /// Wrapper for: func protocol_isEqual(Protocol?, Protocol?) -> Bool
    public static func == (lhs: LMProtocol, rhs: LMProtocol) -> Bool {
        return protocol_isEqual(lhs.protocol, rhs.protocol)
    }
    
    /// Wrapper for: func protocol_isEqual(Protocol?, Protocol?) -> Bool
    public func isEqualTo(protocol: Protocol) -> Bool {
        return protocol_isEqual(self.protocol, `protocol`)
    }

    /// Wrapper for: func protocol_conformsToProtocol(Protocol?, Protocol?) -> Bool
    public func conformsToProtocol(_ protocol: Protocol) -> Bool {
        return protocol_conformsToProtocol(self.protocol, `protocol`)
    }
    
    
    // MARK: To be added in next release:
    
    /// Wrapper for: func objc_allocateProtocol(UnsafePointer<Int8>) -> Protocol?
    
    /// Wrapper for: func objc_registerProtocol(Protocol)
    
    /// Wrapper for: func protocol_addMethodDescription(Protocol, Selector, UnsafePointer<Int8>?, Bool, Bool)
    
    /// Wrapper for: func protocol_addProperty(Protocol, UnsafePointer<Int8>, UnsafePointer<objc_property_attribute_t>?, UInt32, Bool, Bool)
    
    /// Wrapper for: func protocol_copyMethodDescriptionList(Protocol, Bool, Bool, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_method_description>?
    
    /// Wrapper for: func protocol_getMethodDescription(Protocol, Selector, Bool, Bool) -> objc_method_description
    
    /// Wrapper for: func protocol_copyPropertyList(Protocol, UnsafeMutablePointer<UInt32>?) -> UnsafeMutablePointer<objc_property_t>?
    
    /// Wrapper for: func protocol_getProperty(Protocol, UnsafePointer<Int8>, Bool, Bool) -> objc_property_t?
    
    /// Wrapper for: func protocol_copyProtocolList(Protocol, UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?
    
}
