//
//  Util.swift
//  Lumos
//
//  Created by Suyash Shekhar on 16/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation
class Util {
    static func string(for pointer: UnsafePointer<Int8>) -> String {
        return String(cString: pointer)
    }
}
