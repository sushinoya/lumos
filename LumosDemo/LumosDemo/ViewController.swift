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

