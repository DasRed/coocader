//
//  BlockPosition.swift
//  Coocader
//
//  Created by Marco Starker on 07.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import SpriteKit

extension Block {
    class Position {
        // position in matrix
        var matrix: Matrix.Point! = Matrix.Point()
        
        // floating point in matrix
        var matrixAccuracy: CGPoint! = CGPoint()
        
        // position in node
        var node: CGPoint! {
            get {
                return self.nodeByDefaultSize(Block.Size.WIDTH, height: Block.Size.HEIGHT)
            }
        }
        
        // current block
        let block: Block!
        
        // init with block
        init(block: Block) {
            self.block = block
        }
        
        // init full
        init(block: Block, x: Int, y: Int) {
            self.block = block

            self.matrix.x = x
            self.matrix.y = y

            self.matrixAccuracy.x = CGFloat(x)
            self.matrixAccuracy.y = CGFloat(y)
        }

        // init full
        init(block: Block, x: Double, y: Double) {
            self.block = block

            self.matrix.x = Int(floor(x))
            self.matrix.y = Int(floor(y))

            self.matrixAccuracy.x = CGFloat(x)
            self.matrixAccuracy.y = CGFloat(y)
        }

        /// returns theo node position for a definided default node size
        func nodeByDefaultSize(width: Int, height: Int) -> CGPoint {
            return CGPoint(
                x: CGFloat(self.matrixAccuracy.x) * CGFloat(width) + CGFloat(width) / 2.0,
                y: CGFloat(self.matrixAccuracy.y) * CGFloat(height) - CGFloat(height) / 2.0
            )
        }
    }
}