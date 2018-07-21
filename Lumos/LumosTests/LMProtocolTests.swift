//
//  LMProtocolTests.swift
//  LumosTests
//
//  Created by Suyash Shekhar on 21/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import XCTest
@testable import Lumos

class LMProtocolTests: XCTestCase {
    
    static let `protocol`: Protocol = CALayerDelegate.self
    static let lumos = Lumos.for(`protocol`)

    
    func isEqualTo() {
        XCTAssert(LMProtocolTests.lumos.isEqualTo(protocol: LMProtocolTests.protocol))
    }
    
    func conformsToProtocol() {
        LMProtocolTests.lumos.addConformanceTo(protocol: StreamDelegate.self)
        XCTAssert(LMProtocolTests.lumos.conformsToProtocol(StreamDelegate.self))
    }
    
}
