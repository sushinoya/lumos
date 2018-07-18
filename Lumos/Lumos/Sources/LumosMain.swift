//
//  LumosMain.swift
//  Lumos
//
//  Created by Suyash Shekhar on 17/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public extension NSObject {
    public var lumos: LMClass { return LMClass(object: self) }
}
