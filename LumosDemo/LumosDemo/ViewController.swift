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
        let _ = RuntimeHelper()
        
        let x = URLSession()
        
        if let property = x.lumos.getProperty(withName: "trial") {
            let attributes = property.attributes()
            for x in (attributes) {
                print("Key: \(x.name), Value: \(x.value)")
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

class TrialClass: NSObject, Fake, Fake2, Fake5 {
    @objc private weak var trial: UIView?
    @objc let y: String
    static var z: Int = 5
    static let a: Int = 5

    override init() {
        self.trial = UIView()
        self.y = "Trial"
    }
    
    @objc func hi(s: String) -> Int8 {
        return 9
    }
}

@objc protocol Fake {}
@objc protocol Fake1 {}
@objc protocol Fake2 {}
@objc protocol Fake3 {}
protocol Fake4 {}
@objc protocol Fake5 {}

