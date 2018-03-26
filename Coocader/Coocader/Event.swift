//
//  Event.swift
//  Coocader
//
//  Created by Marco Starker on 05.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

class Event {
    // data
    var data: Any?
    
    // name of the event
    var name: String!
    
    // event init
    init(name: String, data: Any? = nil) {
        self.name = name
        self.data = data
    }
}