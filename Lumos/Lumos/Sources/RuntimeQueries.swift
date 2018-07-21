//
//  RuntimeQueries.swift
//  Lumos
//
//  Created by Suyash Shekhar on 20/7/18.
//

import Foundation

extension Lumos {
    
    /// Wrapper for: func objc_getClassList(_ buffer: AutoreleasingUnsafeMutablePointer<AnyClass>?, _ bufferCount: Int32) -> Int32
    public static func getAllClasses() -> [AnyClass] {
        let expectedClassCount = objc_getClassList(nil, 0)
        let allClasses = UnsafeMutablePointer<AnyClass?>.allocate(capacity: Int(expectedClassCount))
        
        let autoreleasingAllClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(allClasses)
        let actualClassCount: Int32 = objc_getClassList(autoreleasingAllClasses, expectedClassCount)
        
        var classes = [AnyClass]()
        for i in 0 ..< actualClassCount {
            if let currentClass: AnyClass = allClasses[Int(i)] {
                classes.append(currentClass)
            }
        }
        
        allClasses.deallocate()
        return classes
    }
    
    /// Wrapper for: func objc_copyProtocolList(UnsafeMutablePointer<UInt32>?) -> AutoreleasingUnsafeMutablePointer<Protocol>?
    public static func getAllProtocols() -> [Protocol] {
        var protocols = [Protocol]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        guard let protocolList = objc_copyProtocolList(count) else {
            return protocols
        }
        
        for protocolCount in 0..<count.pointee {
            let proto = protocolList[Int(protocolCount)]
            protocols.append(proto)
        }
        
        count.deallocate()
        return protocols
    }
}
