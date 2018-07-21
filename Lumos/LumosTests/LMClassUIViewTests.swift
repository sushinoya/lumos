//
//  LMClassUIViewTests.swift
//  LumosTests
//
//  Created by Suyash Shekhar on 21/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import XCTest
@testable import Lumos


class LMClassUIViewTests: XCTestCase {
    
    static let classType = UIView.self
    static let lumos = Lumos.for(classType)
    static let selector = #selector(UIView.addSubview(_:))
    static let selectorString = "alpha"
    let tester = LMClassUIViewTests.self

    func testIsMetaClass() {
        let actual = tester.lumos.isMetaClass()
        let expected = false
        XCTAssert(actual == expected)
    }
    
    
    func testRespondsToSelector() {
        let actual = tester.lumos.respondsToSelector(selector: tester.selector)
        let expected = true
        XCTAssert(actual == expected)
    }
    
    
    func testRespondsToSelectorString() {
        let actual = tester.lumos.respondsToSelector(selectorString: tester.selectorString)
        let expected = true
        XCTAssert(actual == expected)
    }
    
    
    func testConformsToProtocol() {
        let actual = tester.lumos.conformsToProtocol(CALayerDelegate.self)
        let expected = true
        XCTAssert(actual == expected)
    }
    
    
    func testGetName() {
        let actual = tester.lumos.getName()
        let expected = "UIView"
        XCTAssert(actual?.contains(expected) ?? false)
    }
    
    
    func testGetSuperclass() {
        let actual = Lumos.for(tester.lumos.getSuperclass()!).getName()
        let expected = "UIResponder"
        XCTAssert(actual?.contains(expected) ?? false)
    }
    
    
    func testGetInstanceSize() {
        let actual = tester.lumos.getInstanceSize()
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
        let actual = tester.lumos.getVariables().count
        let expected = 49
        XCTAssert(actual == expected)
    }
    
    
    func testGetProperty() {
        let actual = tester.lumos.getProperty(withName: "debugDescription")
        XCTAssert(actual != nil)
    }
    
    
    func testGetProperties() {
        let actual = tester.lumos.getProperties().count
        let expected = 201
        XCTAssert(actual == expected)
    }
    
    
    func testGetProtocols() {
        let actual = tester.lumos.getProtocols().count
        let expected = 29
        XCTAssert(actual == expected)
    }
    
    
    func testGetInstanceMethod() {
        guard let actual = tester.lumos.getInstanceMethod(selector: tester.selector)?.name else { XCTFail(); return }
        let expected = "addSubview:"
        XCTAssert(actual == expected)
    }
    
    func testGetInstanceMethodWithSelector() {
        let actual = tester.lumos.getInstanceMethod(selector: tester.selector)
        XCTAssert(actual != nil)
    }
    
    
    func testGetClassMethodFromString() {
        let actual = tester.lumos.getClassMethod(selectorString: tester.selectorString)?.name
        let expected: String? = nil
        XCTAssert(actual == expected)
    }
    
    func testGetClassMethod() {
        let actual = tester.lumos.getClassMethod(selector: #selector(UIView.setAnimationsEnabled(_:)))
        XCTAssert(actual != nil)
    }
    
    func testGetMethods() {
        let actual = tester.lumos.getMethods().count
        let expected = 1266
        XCTAssert(actual == expected)
    }
    
    
    func testGetImplementation() {
        let actual = tester.lumos.getImplementation(selector: tester.selector)
        let actualType = type(of: actual)
        XCTAssert(actualType == OpaquePointer?.self)
    }
    
    
    func testGetClassHierarchy() {
        let actual = tester.lumos.getClassHierarchy().description
        let expected = "[UIView, UIResponder, NSObject]"
        XCTAssert(actual == expected)
    }
}
