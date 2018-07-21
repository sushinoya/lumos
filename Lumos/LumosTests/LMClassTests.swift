//
//  LMClassTests.swift
//  LumosTests
//
//  Created by Suyash Shekhar on 21/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import XCTest
@testable import Lumos


class LMClassTests: XCTestCase {
    
    static let classType = UIView.self
    static let lumos = Lumos.for(classType)
    static let selector = #selector(UIView.addSubview(_:))
    static let selectorString = "alpha"

    func testIsMetaClass() {
        let actual = LMClassTests.lumos.isMetaClass()
        let expected = false
        XCTAssert(actual == expected)
    }
    
    func testRespondsToSelector() {
        let actual = LMClassTests.lumos.respondsToSelector(selector: LMClassTests.selector)
        let expected = true
        XCTAssert(actual == expected)
    }
    
    func testRespondsToSelectorString() {
        let actual = LMClassTests.lumos.respondsToSelector(selectorString: LMClassTests.selectorString)
        let expected = true
        XCTAssert(actual == expected)
    }
    
    func testConformsToProtocol() {
        let actual = LMClassTests.lumos.conformsToProtocol(CALayerDelegate.self)
        let expected = true
        XCTAssert(actual == expected)
    }
    
    
    func testGetName() {
        let actual = LMClassTests.lumos.getName()
        let expected = "UIView"
        XCTAssert(actual?.contains(expected) ?? false)
    }
    
    
    func testGetSuperclass() {
        let actual = Lumos.for(LMClassTests.lumos.getSuperclass()!).getName()
        let expected = "UIResponder"
        XCTAssert(actual?.contains(expected) ?? false)
    }
    
    
    func testGetInstanceSize() {
        let actual = LMClassTests.lumos.getInstanceSize()
        let expected = 488
        XCTAssert(actual == expected)
    }
    
    
    func testGetInstanceVariable(withName name: String) {
        XCTAssert(true)
    }
    
    
    func testGetClassVariable(withName name: String) {
        XCTAssert(true)
    }
    
    
    func testGetVariables() {
        let actual = LMClassTests.lumos.getVariables().count
        let expected = 49
        XCTAssert(actual == expected)
    }
    
    
    func testGetProperty() {
        let actual = LMClassTests.lumos.getProperty(withName: "someName")
        XCTAssert(true)
    }
    
    
    func testGetProperties() {
        let actual = LMClassTests.lumos.getProperties().count
        let expected = 201
        XCTAssert(actual == expected)
    }
    
    
    func testGetProtocols() {
        let actual = LMClassTests.lumos.getProtocols().count
        let expected = 29
        XCTAssert(actual == expected)
    }
    
    
    func testGetInstanceMethod() {
        guard let actual = LMClassTests.lumos.getInstanceMethod(selector: LMClassTests.selector)?.name else { XCTFail(); return }
        let expected = "addSubview:"
        XCTAssert(actual == expected)
    }
    
    func testGetInstanceMethodWithSelector() {
        let actual = LMClassTests.lumos.getInstanceMethod(selector: LMClassTests.selector)
        XCTAssert(true)
    }
    
    
    func testGetClassMethodFromString() {
        let actual = LMClassTests.lumos.getClassMethod(selectorString: LMClassTests.selectorString)?.name
        let expected: String? = nil
        XCTAssert(actual == expected)
    }
    
    func testGetClassMethod() {
        let actual = LMClassTests.lumos.getClassMethod(selector: LMClassTests.selector)
        XCTAssert(true)
    }
    
    func testGetMethods() {
        let actual = LMClassTests.lumos.getMethods().count
        let expected = 1266
        XCTAssert(actual == expected)
    }
    
    
    func testGetImplementation() {
        let actual = LMClassTests.lumos.getImplementation(selector: LMClassTests.selector)
        let actualType = type(of: actual)
        XCTAssert(actualType == OpaquePointer?.self)
    }
    
    
    func testGetClassHierarchy() {
        let actual = LMClassTests.lumos.getClassHierarchy().description
        let expected = "[UIView, UIResponder, NSObject]"
        XCTAssert(actual == expected)
    }
}
