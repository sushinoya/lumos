  <img width="300" alt="LMMethod Methods" src="https://user-images.githubusercontent.com/23443586/43039911-d3c7a22c-8d69-11e8-92d7-381bc08ed578.gif">

A *light* wrapper around Objective-C Runtime.
# 


## What exactly is ***lumos***?

*lumos* as mentioned is a *light* wrapper around objective-c runtime functions to allow an easier access to the runtime. It makes operations such as swizzling and hooking very simple in Swift.

For example, say you wish to run a block of code whenever a `ViewController`'s `viewDidLoad` method is called

With *lumos*, you can do the following:

```swift
// In AppDelegate (or any conveinient place)..

let method = Lumos.for(ViewController.self).getInstanceMethod(selector: #selector(ViewController.viewDidLoad))
        
method?.prepend {
    // This block will be run every time a viewDidLoad is called
    print("View Controller loaded")
}
````

Similarily you can `append` a block to a method which will be called right before the method returns. You can even use `replace` to replace the method's implementation with the block you pass in as a parameter.

If you wanted more flexibility, you could swizzle the `viewDidLoad` method using the following lines:

```swift
@objc func myMethod() {
    // Do anything here
}

let myMethod = self.lumos.getInstanceMethod(selector: #selector(myMethod))

method?.swapImplementation(with: myMethod)
```

Do you feel the superpower yet? Maybe you wish to list all the classes registered at runtime:

```swift
Lumos.getAllClasses()
```

*Fun Fact:* There are almost *12,000* classes registered at runtime Try `Lumos.getAllClasses().count`



You could get the class hierarchy of any class just with:

```swift
myObject.lumos.getClassHierarcy()   // For UIView: [UIView, UIResponder, NSObject]
```
*Fun Fact:* Some classes such as `URLSessionTask` are actually dummy classes which are replaced with underlying classes such as `__NSCFLocalSessionTask` during runtime.

With *lumos*, you can iterate through variables, functions, protocols etc and meddle with them at runtime. Have fun exploring!

## Usage
Just incantate `.lumos` on any instance of a `NSObject` subclass or use `Lumos.for(object)` for where `object` is of type `AnyClass`, `AnyObject`, `Protocol`, `Ivar`, `objc_property_t` or `objc_property_attribute_t`.

<img width="728" alt="LMMethod Methods" src="https://user-images.githubusercontent.com/23443586/43019596-2127777a-8c90-11e8-9735-389171e59ff3.png">

<img width="728" alt="LMClass Methods" src="https://user-images.githubusercontent.com/23443586/43020763-b02b3314-8c93-11e8-852c-79e6365e556c.png">



P.s The code itself *is* the documentation for now. There are many more methods that *lumos* offers which are not discussed in this document. Cheers :)

## Why ***lumos***?

The [Objective-C Runtime](https://developer.apple.com/documentation/objectivec/objective_c_runtime) provides many powerful methods to manipulate objects, classes and methods at runtime. Although disasterous when misused, these methods provide a great way to peek into the runtime and meddle with it.


However, the methods are not exactly easy to use sometimes. For example the following method is used to obtain a list of all classes registered at runtime: 
```swift
func objc_getClassList(_ buffer: AutoreleasingUnsafeMutablePointer<AnyClass>?, _ bufferCount: Int32) -> Int32
```

Often, a lot of dirty work needs to be done before one gets the list out. Here is how I would do it:

```swift
static func getClassList() -> [AnyClass] {
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
    return Lumos.getClassList().filter { class_conformsToProtocol($0, requiredProtocol) }
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

You can now use:
```swift
Lumos.swizzle(originalClass: URLSessionTask,
              originalSelector: #selector(URLSessionTask.resume),
              swizzledClass: SwizzledSessionTask,
              swizzledSelector: #selector(SwizzledSessionTask.resume))
```

P.S you might want to use `dispatch_once` with the method above to above swizzling more than once across multiple threads.

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate *lumos* into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Lumos'
end
```

Then, run the following command:

```bash
$ pod install
```

## License

Lumos is released under the Apache-2.0. See [LICENSE](https://github.com/sushinoya/Lumos/blob/master/LICENSE) for details.

