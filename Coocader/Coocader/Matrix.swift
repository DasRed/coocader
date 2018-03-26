import Foundation
import SpriteKit

class Matrix: EventManagerProtocol {
    
    // max width
    static let MAX_WIDTH = 10
    
    enum EventType: String, EventTypeProtocol {
        case BlockWasRemoved = "game.matrix.blockWasRemove" // in data is the removed block as Block
        case LineWasRemoved = "game.matrix.lineWasRemoved" // in data is the removed line number as Int
        case BlockWasAppend = "game.matrix.blockWasAppend" // a block was added. data contains the block
    }
    
    // all blocks
    internal private(set) var blocks: [Int: [Int: Block]] = [:]
    
    // constructor
    init() {}

    /// creates a copy of this
    func copy() -> Matrix {
        let result = Matrix()

        for blocks in self.blocks.values {
            for block in blocks.values {
                result.append(block.copy())
            }
        }

        return result
    }

    /// append a block to the position from block
    func append(block: Block) {
        self.append(block, x: block.position.matrix.x, y: block.position.matrix.y)
    }

    /// append a block to a position
    func append(block: Block, x: Int, y: Int) {
        if (self.blocks[y] == nil) {
            self.blocks[y] = [:]
        }

        self.blocks[y]![x] = block
        self.trigger(Matrix.EventType.BlockWasAppend, block)
    }

    // appends a new line of blocks
    func appendLine(blocks: [Int: Block]) -> Matrix {
        var y = 0
        let keys = self.blocks.keys
        if (keys.count != 0) {
            y = keys.maxElement()! + 1
        }
        self.blocks[y] = blocks
        
        for block in blocks.values {
            block.position.matrix.y = y
            block.position.matrixAccuracy.y = CGFloat(y)
            self.trigger(Matrix.EventType.BlockWasAppend, block)
        }
        
        return self
    }
    
    // creates one line of blocks
    func createLine() -> [Int: Block] {
        var blocks: [Int: Block] = [:]
        var block: Block
        
        var x: Int = Matrix.MAX_WIDTH - 1
        while (x >= 0) {
            block = Block(maxWidth: x)

            switch block.width! {
            case .Once:
                block.position.matrix.x = x - 0
                block.position.matrixAccuracy.x = CGFloat(x) - 0.0
                break

            case .Double:
                block.position.matrix.x = x - 1
                block.position.matrixAccuracy.x = CGFloat(x) - 0.5
                break

            case .Triple:
                block.position.matrix.x = x - 1
                block.position.matrixAccuracy.x = CGFloat(x) - 1.0
                break

            case .Quadruple:
                block.position.matrix.x = x - 2
                block.position.matrixAccuracy.x = CGFloat(x) - 1.5
                break

            case .Fivefold:
                block.position.matrix.x = x - 2
                block.position.matrixAccuracy.x = CGFloat(x) - 2.0
                break

            }
            blocks[block.position.matrix.x] = block
            
            x -= block.width.toInt() + 1
        }

        return blocks
    }
    
    // creates one line of blocks and append them
    func createAndAppendLine() -> [Int: Block] {
        let blocks = self.createLine()
        self.appendLine(blocks)
        
        return blocks
    }
    
    // create and append given count of lines
    func createAndAppendLines(var countOfLines lines: Int) -> Matrix {
        for ; lines > 0; lines-- {
            self.createAndAppendLine()
        }
        
        return self
    }
    
    // removes the block from matrix
    func removeBlock(block : Block) -> Matrix {
        let position = block.position.matrix
        
        guard self.blocks[position.y] != nil else {
            return self
        }
        
        guard self.blocks[position.y]![position.x] != nil else {
            return self
        }

        // remove the block
        self.blocks[position.y]!.removeValueForKey(position.x)
        self.trigger(Matrix.EventType.BlockWasRemoved, block)
        
        // if the line empty remove the line too
        if (self.blocks[position.y]!.count == 0) {
            self.blocks.removeValueForKey(position.y)
            self.trigger(Matrix.EventType.LineWasRemoved, position.y)
        }
        
        return self
    }
}