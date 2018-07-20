//
//  Swizzler.swift
//  Lumos
//
//  Created by Suyash Shekhar on 20/7/18.
//

import Foundation

extension Lumos {
    
    // Objective-C Methods used directly instead of LM wrapper structs to avoid overhead
    public static func swizzle(originalClass: AnyClass, originalSelector: Selector, swizzledClass: AnyClass, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(originalClass, originalSelector),
            let swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector) else {
                return
        }
        
        let didAddMethod = class_addMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(originalClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}
