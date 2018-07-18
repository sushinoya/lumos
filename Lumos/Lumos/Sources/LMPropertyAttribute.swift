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
    public let value: String // Empty string in most cases
    public let rawStruct: objc_property_attribute_t
    
    init(rawStruct: objc_property_attribute_t) {
        self.name = String(cString: rawStruct.name)
        self.value = String(cString: rawStruct.value)
        self.rawStruct = rawStruct
    }
}
