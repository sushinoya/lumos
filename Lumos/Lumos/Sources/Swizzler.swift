//
//  Swizzler.swift
//  Lumos
//
//  Created by Suyash Shekhar on 20/7/18.
//

import Foundation

extension Lumos {
    
    // Objective-C Methods used directly instead of LM wrapper structs to avoid overhead
    public static func swizzle(type: MethodType, originalClass: AnyClass, originalSelector: Selector, swizzledClass: AnyClass, swizzledSelector: Selector) {
        
        let firstMethod: Method?
        let secondMethod: Method?
        
        switch type {
        case .instance:
            firstMethod = class_getInstanceMethod(originalClass, originalSelector)
            secondMethod = class_getInstanceMethod(swizzledClass, swizzledSelector)
        case .class:
            firstMethod = class_getClassMethod(originalClass, originalSelector)
            secondMethod = class_getClassMethod(swizzledClass, swizzledSelector)
        }
        
        guard let originalMethod = firstMethod,
              let swizzledMethod = secondMethod else { return }
        
        let didAddMethod = class_addMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(originalClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        // Logging
        Lumos.registerSwizzle(type: type, originalClass: originalClass, originalSelector: originalSelector, swizzledClass: swizzledClass, swizzledSelector: swizzledSelector)
    }
    
    static func registerSwizzle(originalClass: AnyClass, originalSelector: Selector, originalMethodType: MethodType, swizzledClass: AnyClass, swizzledSelector: Selector, swizzledMethodType: MethodType) {
        let entry = SwizzleEntry(originalClass: originalClass, originalSelector: originalSelector, originalMethodType: originalMethodType, swizzledClass: swizzledClass, swizzledSelector: swizzledSelector, swizzledMethodType: swizzledMethodType)
        
        let contrastingEntry = SwizzleEntry(originalClass: swizzledClass, originalSelector: swizzledSelector, originalMethodType: swizzledMethodType, swizzledClass: originalClass, swizzledSelector: originalSelector, swizzledMethodType: originalMethodType)
        
        if Lumos.swizzles.contains(contrastingEntry) {
            guard let index = Lumos.swizzles.firstIndex(of: contrastingEntry) else { return }
            Lumos.swizzles.remove(at: index)
        } else {
            Lumos.swizzles.append(entry)
        }
    }
    
    static func registerSwizzle(type: MethodType, originalClass: AnyClass, originalSelector: Selector, swizzledClass: AnyClass, swizzledSelector: Selector) {
        Lumos.registerSwizzle(originalClass: originalClass, originalSelector: originalSelector, originalMethodType: type, swizzledClass: swizzledClass, swizzledSelector: swizzledSelector, swizzledMethodType: type)
    }
}

public struct SwizzleEntry: Equatable {
    let originalClass: AnyClass
    let originalSelector: Selector
    let originalMethodType: MethodType
    let swizzledClass: AnyClass
    let swizzledSelector: Selector
    let swizzledMethodType: MethodType

    public static func == (lhs: SwizzleEntry, rhs: SwizzleEntry) -> Bool {
        return lhs.originalClass == rhs.originalClass &&
               lhs.originalSelector == rhs.originalSelector &&
               lhs.swizzledClass == rhs.swizzledClass &&
               lhs.swizzledSelector == rhs.swizzledSelector &&
               lhs.originalMethodType == rhs.originalMethodType &&
               lhs.swizzledMethodType == rhs.swizzledMethodType
    }
    
    func contrastingEntry() -> SwizzleEntry {
        return SwizzleEntry(originalClass: swizzledClass, originalSelector: swizzledSelector, originalMethodType: swizzledMethodType, swizzledClass: originalClass, swizzledSelector: originalSelector, swizzledMethodType: originalMethodType)
    }
    
    func performSwizzle() {
        if originalMethodType == swizzledMethodType {
            Lumos.swizzle(type: originalMethodType, originalClass: originalClass, originalSelector: originalSelector, swizzledClass: swizzledClass, swizzledSelector: swizzledSelector)
        } else {
            guard let originalMethod = getMethod(ofType: originalMethodType, class: originalClass, selector: originalSelector),
                let swizzledMethod = getMethod(ofType: swizzledMethodType, class: swizzledClass, selector: swizzledSelector) else {
                    return
            }
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    func performSwizzleBack() {
        self.contrastingEntry().performSwizzle()
    }
    
    func getMethod(ofType type: MethodType, class: AnyClass, selector: Selector) -> Method? {
        switch type {
        case .instance: return class_getInstanceMethod(`class`, selector)
        case .class: return class_getClassMethod(`class`, selector)
        }
    }
}
