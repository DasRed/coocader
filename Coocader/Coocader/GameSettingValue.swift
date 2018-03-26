//
//  GameSettingValue.swift
//  Coocader
//
//  Created by Marco Starker on 12.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

extension GameSetting {
    
    // value definition
    struct Value {
        // this is the offset
        var offset: Float {
            didSet {
                if (self.offset < 0) {
                    self.offset = 0
                }
            }
        }
        
        // this is per iteration
        var perIteration: Float!
        
        // function to calc
        var iterationFunction: ValueIterationFunction = .Linear
        
        // iteration
        private(set) var iteration: Int! = 0
        
        // min calced value
        var min: Float?
        
        // max calced value
        var max: Float?
        
        // construct
        init(_ offset: Float, _ perIteration: Float = 0, _ iterationFunction: ValueIterationFunction = .Linear) {
            self.offset = offset
            self.perIteration = perIteration
            self.iterationFunction = iterationFunction
        }
        
        // construct
        init(_ offset: Float, _ perIteration: Float, _ iterationFunction: ValueIterationFunction, min: Float) {
            self.offset = offset
            self.perIteration = perIteration
            self.iterationFunction = iterationFunction
            self.min = min
        }

        // construct
        init(_ offset: Float, _ perIteration: Float, _ iterationFunction: ValueIterationFunction, min: Float, max: Float) {
            self.offset = offset
            self.perIteration = perIteration
            self.iterationFunction = iterationFunction
            self.min = min
            self.max = max
        }
        
        // construct
        init(_ offset: Float, _ perIteration: Float, _ iterationFunction: ValueIterationFunction, max: Float) {
            self.offset = offset
            self.perIteration = perIteration
            self.iterationFunction = iterationFunction
            self.max = max
        }
        
        // construct
        init(_ offset: Float, _ perIteration: Float, min: Float) {
            self.offset = offset
            self.perIteration = perIteration
            self.min = min
        }
        
        // construct
        init(_ offset: Float, _ perIteration: Float, min: Float, max: Float) {
            self.offset = offset
            self.perIteration = perIteration
            self.min = min
            self.max = max
        }

        // construct
        init(_ offset: Float, _ perIteration: Float, max: Float) {
            self.offset = offset
            self.perIteration = perIteration
            self.max = max
            
        }
        // construct
        init(_ offset: Float, iterations: Int) {
            self.offset = offset
            self.perIteration = offset / Float(iterations)
            self.min = 0
        }
        
        // construct
        init(_ offset: Float, iterations: Int, min: Float) {
            self.offset = offset
            self.perIteration = offset / Float(iterations)
            self.min = min
        }
        
        // construct
        init(_ offset: Float, iterations: Int, min: Float, max: Float) {
            self.offset = offset
            self.perIteration = offset / Float(iterations)
            self.min = min
            self.max = max
        }
        
        // construct
        init(_ offset: Float, iterations: Int, max: Float) {
            self.offset = offset
            self.perIteration = offset / Float(iterations)
            self.max = max
        }
        
        // calc value and increase iteration index
        mutating func calc() -> Float {
            let value = self.calcByIteration(self.iteration)
            
            self.iteration = self.iteration + 1
            
            return value
        }
        
        // gets result for offset and perIteration for a iteration
        func calcByIteration(iteration: Int) -> Float {
            var value: Float
            
            switch self.iterationFunction {
                
            case .Linear:
                value = self.offset + self.perIteration * Float(iteration)
                break
                
            case .PowerOfTwo:
                value = self.offset + Float(pow(Double(self.perIteration), Double(iteration)))
                break
                
            case .PowerOfTwoForIteration:
                value = self.offset + Float(pow(Double(iteration), Double(self.perIteration)))
                break
             
            case .Logical:
                value = self.offset + self.perIteration * log(Float(iteration))
                break
                
            }
            
            // out of range for min
            if (self.min != nil && value < self.min!) {
                value = self.min!
            }
            
            // out of range for max
            if (self.max != nil && value > self.max) {
                value = self.max!
            }
            
            return value
        }
    }
    
    // type function
    enum ValueIterationFunction: String {
        case Linear = "linear"
        case PowerOfTwo = "pot"
        case PowerOfTwoForIteration = "poti"
        case Logical = "logical"
    }
}