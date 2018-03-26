//
//  Function.swift
//  Coocader
//
//  Created by Marco Starker on 06.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension Int {
    func random(max: Int) -> Int {
        return self + Int(arc4random_uniform(UInt32(max - self + 1)))
    }
}
