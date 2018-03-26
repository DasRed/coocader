//
//  BlockSize.swift
//  Coocader
//
//  Created by Marco Starker on 07.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

extension Block {
    class Size {
        
        // default with
        static let WIDTH: Int = 55
        
        // default height
        static let HEIGHT: Int = 55
        
        // width
        let width: Int!
        
        // height
        let height: Int!
        
        // init
        init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }
}