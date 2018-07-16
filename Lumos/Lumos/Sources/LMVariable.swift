//
//  InstanceVariable.swift
//  Lumos
//
//  Created by Suyash Shekhar on 16/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import Foundation

public struct LMVariable {
    let ivar: Ivar
    let name: String
    let offset: Int
    let typeEncoding: String
    
    init?(ivar: Ivar) {
        guard let name = LMVariable.getName(ivar: ivar),
              let typeEncoding = LMVariable.getTypeEncoding(ivar: ivar)
        else { return nil }
        
        self.ivar = ivar
        self.name = name
        self.offset = LMVariable.getOffset(ivar: ivar)
        self.typeEncoding = typeEncoding
    }
}

extension LMVariable {
    
    static func getName(ivar: Ivar) -> String? {
        guard let namePointer = ivar_getName(ivar) else { return nil }
        return String(cString: namePointer)
    }
    
    static func getOffset(ivar: Ivar) -> Int {
        return ivar_getOffset(ivar)
    }
    
    static func getTypeEncoding(ivar: Ivar) -> String? {
        guard let typePointer = ivar_getTypeEncoding(ivar) else { return nil }
        return String(cString: typePointer)
    }
}
