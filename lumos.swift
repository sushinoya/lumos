import Foundation

class Lumos {
    
    static func swizzle(originalClass: AnyClass, originalSelector: Selector, swizzledClass: AnyClass, swizzledSelector: Selector) {
        guard let originalMethod = class_getInstanceMethod(originalClass, originalSelector),
            let swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector) else {
                print("Swizzling Failed")
                return
        }
        
        let didAddMethod = class_addMethod(originalClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
        
        if didAddMethod {
            class_replaceMethod(originalClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
    
    
    static func classList() -> [AnyClass] {
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
    
    static func classesImplementingProtocol(_ requiredProtocol: Protocol) -> [AnyClass] {
        return classList().filter { class_conformsToProtocol($0, requiredProtocol) }
    }
    
    
    static func getClassHierarchy(for requiredClass: AnyClass) -> String {
        var hierarcy = [String]()
        hierarcy.append(requiredClass.description())
        var currentSuper: AnyClass? = class_getSuperclass(requiredClass)
        while currentSuper != nil {
            hierarcy.append(currentSuper!.description())
            currentSuper = class_getSuperclass(currentSuper)
        }
        
        return hierarcy.joined(separator: " -> ")
    }
}