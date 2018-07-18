//
//  LMProperty.swift
//  Lumos
//
//  Created by Suyash Shekhar on 17/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public struct LMProperty {
   
    public let pointer: objc_property_t
    public let name: String
    
    init(propertyPointer: objc_property_t) {
        self.pointer = propertyPointer
        self.name = String(cString: property_getName(propertyPointer))
    }
    
    public lazy var attributesDescription: String? = {
        guard let attributesString = property_getAttributes(self.pointer) else { return nil }
        return String(cString: attributesString)
    }()
    
    public func attributes() -> [LMPropertyAttribute] {
        var attributes = [LMPropertyAttribute]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        guard let attributeList = property_copyAttributeList(self.pointer, count) else {
            return attributes
        }
        
        for attributeCount in 0..<count.pointee {
            let attribute = attributeList[Int(attributeCount)]
            attributes.append(LMPropertyAttribute(rawStruct: attribute))
        }
        
        attributeList.deallocate()
        count.deallocate()
        return attributes
    }
}
