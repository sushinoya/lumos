//
//  LMPropertyAttribute.swift
//  Lumos
//
//  Created by Suyash Shekhar on 18/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public struct LMPropertyAttribute {
    
    public let name: String
    public let value: String? // Empty string in most cases
    public let rawStruct: objc_property_attribute_t
    
    init(rawStruct: objc_property_attribute_t) {
        self.name = LMPropertyAttribute.nameDescription(for: rawStruct.name)
        self.rawStruct = rawStruct
        let value = String(cString: rawStruct.value)
        
        guard !value.isEmpty else {
            self.value = nil
            return
        }
        self.value = value
    }
    
    private static func nameDescription(for argumentType: UnsafePointer<Int8>) -> String {
        let stringRepresentation = String(cString: argumentType)
        switch stringRepresentation {
        case "R": return "readOnly"
        case "N": return "nonAtomic"
        case "D": return "dynamic"
        case "W": return "weak"
        case "C": return "copy"
        case "&": return "retain"
        case "G": return "getterSelector"
        case "S": return "selector"
        case "T": return "typeEncoding"
        case "V": return "variableName"
        default: return stringRepresentation }
    }
}
