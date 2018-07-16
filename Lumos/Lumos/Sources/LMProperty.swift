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
    
    public lazy var attributesDescription: String? = {
        guard let attributesString = property_getAttributes(self.pointer) else { return nil }
        return String(cString: attributesString)
    }()
    
//    lazy var attributesPointers: [objc_property_attribute_t] = {
//        let expectedAttributesCount = property_copyAttributeList(self.pointer, UnsafeMutablePointer<UInt32>.allocate(capacity: 0))
//        let allAttributes = UnsafeMutablePointer<objc_property_attribute_t?>.allocate(capacity: Int(expectedAttributesCount))
//        let autoreleasingAllAttributes = AutoreleasingUnsafeMutablePointer<objc_property_attribute_t>(allAttributes)
//        let actualAttributeCount: Int32 = property_copyAttributeList(autoreleasingAllAttributes, expectedAttributesCount)
//
//        var attributes = [objc_property_attribute_t]()
//        for i in 0 ..< actualAttributeCount {
//            if let currentClass: objc_property_attribute_t = allAttributes[Int(i)] {
//                attributes.append(currentClass)
//            }
//        }
//
//        allAttributes.deallocate()
//        return attributes
//    }()
    
    public init(propertyPointer: objc_property_t) {
        self.pointer = propertyPointer
        self.name = String(cString: property_getName(propertyPointer))
    }
}
