//
//  File.swift
//  Coocader
//
//  Created by Marco Starker on 05.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

class EventListener {
    
    // callback
    var callback: ((event: Event) -> Any?)! = {(event: Event) in return nil }
    
    // a reference
    var reference: AnyObject? = nil
    
    init() {}
    
    // callback just call
    init(callback: ((event: Event) -> Any?), reference: AnyObject? = nil) {
        self.replaceCallback(callback)
        self.reference = reference
    }
    
    // callback without result
    init(callback: ((event: Event) -> Void), reference: AnyObject? = nil) {
        self.replaceCallback(callback)
        self.reference = reference
    }
    
    // callback with result but without event parameter
    init(callback: (() -> Any?), reference: AnyObject? = nil) {
        self.replaceCallback(callback)
        self.reference = reference
    }
    
    // callback without result and without event parameter
    init(callback: (() -> Void), reference: AnyObject? = nil) {
        self.replaceCallback(callback)
        self.reference = reference
    }
    
    // raise 
    func raise(event: Event) -> Any? {
        return self.callback(event: event)
    }

    /// sets the callback
    func replaceCallback(callback: ((event: Event) -> Any?)) {
        self.callback = callback
    }

    /// sets the callback
    func replaceCallback(callback: ((event: Event) -> Void)) {
        self.callback = {(event: Event) in
            callback(event: event)
            return nil
        }
    }

    /// sets the callback
    func replaceCallback(callback: (() -> Any?)) {
        self.callback = {(event: Event) in
            return callback()
        }
    }

    /// sets the callback
    func replaceCallback(callback: (() -> Void)) {
        self.callback = {(event: Event) in
            callback()

            return nil
        }
    }
}