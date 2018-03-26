//
//  Enum.swift
//  Coocader
//
//  Created by Marco Starker on 07.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

protocol BlockTypeEnumProtocol {
    // returns all enums
    static func all() -> [Self]
    
    // random
    static func random() -> Self
    
    // random
    static func random(max: Int) -> Self
    
    // random
    static func random(var min: Int, var max: Int) -> Self
    
    // weight of creation
    static func weightingsOfCreation() -> [Range <Int>]
}

extension BlockTypeEnumProtocol {
    // random
    static func random() -> Self {
        return Self.random(0, max: Self.all().count)
    }
    
    // random
    static func random(max: Int) -> Self {
        return Self.random(0, max: max)
    }
    
    // random
    static func random(var min: Int, var max: Int) -> Self {
        let all = Self.all()

        if (min < 0) {
            min = 0
        }

        if (max > all.count - 1) {
            max = all.count - 1
        }
        
        // width by weighting
        let weightingsOfCreation = Self.weightingsOfCreation()
        let randomValue = weightingsOfCreation[min].startIndex.random(weightingsOfCreation[max].endIndex - 1)
        
        for (index, weighting) in weightingsOfCreation.enumerate() {
            if (weighting.contains(randomValue) == true) {
                return all[index]
            }
        }

        NSLog("WEIGHT RANDOM FAILD")
        return all[min.random(max)]
    }
}