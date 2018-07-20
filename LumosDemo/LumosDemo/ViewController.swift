//
//  ViewController.swift
//  LumosDemo
//
//  Created by Suyash Shekhar on 16/7/18.
//  Copyright © 2018 io.sushinoya. All rights reserved.
//

import UIKit
import Lumos

class ViewController: UIViewController {
    
    @objc dynamic func iJustCantLook() -> String {
        print("iJustCantLook")
        let x = true
        if x {
            print("holy jesus")
            return "hakuna"
        } else {
            return "Matata"
        }
        
        return "TrialClass()"
    }
    
    @objc dynamic func iJustCasntLook() -> Void {
        print("iJustCanstLook")
//        return "hakuna"

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trialObject = TrialClass()
        trialObject.function()
        
        let method = Lumos.for(ViewController.self).getInstanceMethod(selector: #selector(ViewController.iJustCantLook))!
        
        
        method.replace { print("spiderman") }
        
        print(self.iJustCantLook())
        
        trialObject.function()
        
        let methods = LMClass(class: TrialClass.self).getMethods()
        
        for method in methods {
            print(method.name)
        }
        

        let x = URLSession()
        
        print(x.lumos.getClassHierarchy())

        if let property = x.lumos.getProperties().first {
            let attributes = property.attributes()
            
            for x in (attributes) {
                
                
                print("Key: \(x.name), Value: \(x.value ?? "nil")")
            }
        }

        for variable in x.lumos.getVariables() {
            print(variable.name)
        }

        for property in x.lumos.getProperties() {
            print(property.attributes())
        }

        let y = TrialClass()
        print(y.lumos.getInstanceMethod(selector: #selector(TrialClass.hi)))


        for proto in x.lumos.getProtocols() {
            print(proto)
        }
    }
}

class TrialClass: NSObject {
    @objc private weak var trial: UIView?
    @objc let y: String
    @objc static var z: Int = 5
    @objc static let a: Int = 5

     override init() {
        self.trial = UIView()
        self.y = "Trial"
    }
    
    @objc func hi(s: String) -> Int8 {
        return 9
    }
    
    @objc dynamic func function() {
        print("original function")
    }
    
    @objc class func fakeFunc() {
        print("code injected")
    }
    
    static func swizzle() {
        let lumos = Lumos.for(TrialClass.self)
        guard let m1 = lumos.getInstanceMethod(selector: #selector(TrialClass.function)),
              let m2 = lumos.getInstanceMethod(selector: #selector(TrialClass.fakeFunc)) else {
                print("could not get methods"); return
        }
        
        m1.swapImplementation(with: m2)
    }
}

@objc protocol Fake {}
@objc protocol Fake1 {}
@objc protocol Fake2 {}
@objc protocol Fake3 {}
@objc protocol Fake4 {}

