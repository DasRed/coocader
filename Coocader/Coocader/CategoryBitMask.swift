//
//  CategoryBitMask.swift
//  Coocader
//
//  Created by Marco Starker on 11.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

enum CategoryBitMask: UInt32 {
    case Shot           = 0b00000000000000000000000000000000
    case Block          = 0b00000000000000000000000000000001
    case Deathline      = 0b00000000000000000000000000000010
    case Ship           = 0b00000000000000000000000000000100
    case GunnerShot     = 0b00000000000000000000000000001000
    case Gift           = 0b00000000000000000000000000010000
}