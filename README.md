# **lumos**
A *light* wrapper around Objective-C Runtime.

## Usage
Just incantate `.lumos` on any instance of a `NSObject` subclass or use `LMClass(object: AnyObject)` or `LMClass(class _class: AnyClass)` for classes which do not subclass `NSObject`

<img width="759" alt="screen shot 2018-07-19 at 12 44 49 am" src="https://user-images.githubusercontent.com/23443586/42896777-879fa7da-8af0-11e8-9c8d-f35d0e2130b7.png">



<img width="440" alt="screen shot 2018-07-19 at 12 47 27 am" src="https://user-images.githubusercontent.com/23443586/42896778-87e73c6c-8af0-11e8-88e0-27f3c15474ef.png">


## What exactly is ***lumos***?

*lumos* as mentioned is a *light* wrapper around objective-c runtime functions to allow an easier access to the runtime. However, its sourcecode can also serve as a reference for many of these methods and their usages. The project is still in its infancy and more features and functionality will be added in the upcoming months.


## Why ***lumos***?

The [Objective-C Runtime](https://developer.apple.com/documentation/objectivec/objective_c_runtime) provides many powerful methods to manipulate objects, classes and methods at runtime. Although disasterous when misused, these methods provide a great way to peek into the runtime and meddle with it.

However, the methods are not exactly easy to use sometimes. For example the following method is used to obtain a list of all classes registered at runtime: 
```swift
func objc_getClassList(_ buffer: AutoreleasingUnsafeMutablePointer<AnyClass>?, _ bufferCount: Int32) -> Int32
```

However, a lot of dirty work needs to be done before one gets the list out. Here is how I would do it:

```swift
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
```

Now all you would need to do to obtain the list of classes would be to invoke this method. Maybe you wish to get a list of classes that conform to a certain protocol:

```swift
static func classesImplementingProtocol(_ requiredProtocol: Protocol) -> [AnyClass] {
    return classList().filter { class_conformsToProtocol($0, requiredProtocol) }
}
```


Perhaps you wish to swizzle method implementations at runtime:

```swift
static func swizzle(originalClass: AnyClass, originalSelector: Selector, swizzledClass: AnyClass, swizzledSelector: Selector) {
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
```

P.S you might want to use `dispatch_once` with the method above to above swizzling more than once across multiple threads.

## Installation

### Manual

- In your project directory, 
`git clone www.github.com/sushinoya/lumos.git`

- In your project settings, include `Lumos.framework`

### Others 

Keep a look out for **Cocoapod** and **Carthage** releases.