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
    
    @objc class dynamic func fakeFunc() {
        print("code injected")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for cls in Lumos.getAllClasses() {
            let lumoscls = Lumos.for(cls)
            guard let name =  lumoscls.getName() else { continue }
            guard name.contains("Lumos")  else { continue }
            
            print("")
            print(name)
            
            for prop in lumoscls.getVariables() {
                print(prop.name)
            }
            
            for mehod in lumoscls.getMethods() {
                print(mehod.name)
            }
        }
        
        let method1 = self.lumos.getClassMethod(selector: #selector(ViewController.fakeFunc))
        let method2 = Lumos.for(TrialClass.self).getInstanceMethod(selector: #selector(TrialClass.function))!

        method1?.swapImplementation(with: method2)
        
        let trial = TrialClass()
        trial.function()
        
//        Lumos.swizzle(type: .instance,
//                      originalClass: TrialClass.self,
//                      originalSelector: #selector(TrialClass.function),
//                      swizzledClass: ViewController.self,
//                      swizzledSelector: #selector(ViewController.fakeFunc))
//
//        let trial = TrialClass()
//        trial.function()
//        print(Lumos.swizzles)
//
//
//        Lumos.swizzle(type: .instance,
//                      originalClass: ViewController.self,
//                      originalSelector: #selector(ViewController.fakeFunc),
//                      swizzledClass: TrialClass.self,
//                      swizzledSelector: #selector(TrialClass.function))
//
//        let trial2 = TrialClass()
//        trial2.function()
//        print(Lumos.swizzles)

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
}

