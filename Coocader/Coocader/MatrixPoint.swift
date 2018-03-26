//
//  MatrixPoint.swift
//  Coocader
//
//  Created by Marco Starker on 07.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

extension Matrix {
    class Point {
        // x position in matrix
        var x: Int = 0
        
        // y position in matrix
        var y: Int = 0
        
        // construct
        init() {}
        
        // constructor
        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }
    }
}