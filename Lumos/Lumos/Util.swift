//
//  Util.swift
//  Lumos
//
//  Created by Suyash Shekhar on 16/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public extension String {
    func toPointer(completion: @escaping (UnsafePointer<Int8>) -> ()) {
        self.withCString { (pointer) -> () in
            completion(pointer)
        }
    }
    
    // Source: https://github.com/apple/swift/blob/master/stdlib/public/core/Pointer.swift#L85-L92
    public func toPointer() -> UnsafePointer<Int8> {
        let utf8 = Array(self.utf8CString)
        return _convertConstArrayToPointerArgument(utf8).1
    }
}
