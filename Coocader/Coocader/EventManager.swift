//
//  EventManager.swift
//  Coocader
//
//  Created by Marco Starker on 05.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation

class EventManager {
    
    // events with special catch all *
    private var events: [String: [EventListener]]! = ["*": []]
    
    // shared instance
    static private var instance: EventManager?
    
    // returns a global chared instance
    static func sharedEventManager() -> EventManager {
        if (EventManager.instance == nil) {
            EventManager.instance = EventManager()
        }
        
        return EventManager.instance!
    }

    /***************************** ADD with Function + Event */

    // add multiple listeners with function + Event
    func addListeners<E: EventTypeProtocol>(listeners: [E: (event: Event) -> Void], _ reference: AnyObject? = nil) -> EventManager {
        for (eventName, listener) in listeners {
            self.addListener(eventName, listener, reference)
        }
        
        return self
    }
    
    // add an listener
    func addListener<E: EventTypeProtocol>(eventName: E, _ listener: ((event: Event) -> Void), _ reference: AnyObject? = nil) -> EventManager {
        return self.addListener(eventName, EventListener(callback: listener, reference: reference))
    }
    
    // add an listener
    func addListener(eventName: String, _ listener: ((event: Event) -> Void), _ reference: AnyObject? = nil) -> EventManager {
        return self.addListener(eventName, EventListener(callback: listener, reference: reference))
    }
    
    /***************************** ADD with Function */

    // add multiple listeners
    func addListeners<E: EventTypeProtocol>(listeners: [E: () -> Void], _ reference: AnyObject? = nil) -> EventManager {
        for (eventName, listener) in listeners {
            self.addListener(eventName, listener, reference)
        }

        return self
    }
    
    // add an listener
    func addListener<E: EventTypeProtocol>(eventName: E, _ listener: (() -> Void), _ reference: AnyObject? = nil) -> EventManager {
        return self.addListener(eventName, EventListener(callback: listener, reference: reference))
    }
    
    // add an listener
    func addListener(eventName: String, _ listener: (() -> Void), _ reference: AnyObject? = nil) -> EventManager {
        return self.addListener(eventName, EventListener(callback: listener, reference: reference))
    }
    
    /***************************** ADD */

    // add multiple listeners
    func addListeners<E: EventTypeProtocol>(listeners: [E: EventListener]) -> EventManager {
        for (eventName, listener) in listeners {
            self.addListener(eventName, listener)
        }
        
        return self
    }
    
    // add an listener
    func addListener<E: EventTypeProtocol>(eventName: E, _ listener: EventListener) -> EventManager {
        return self.addListener(String(eventName.rawValue), listener)
    }
    
    // add an listener
    func addListener(eventName: String, _ listener: EventListener) -> EventManager {
        if (self.events[eventName] == nil) {
            self.events[eventName] = []
        }
        
        self.events[eventName]?.append(listener)
        
        return self
    }
    
    /***************************** REMOVE */
    // remove a listener
    func removeListener<E: EventTypeProtocol>(eventName: E, _ listener: EventListener) -> EventManager {
        return self.removeListener(String(eventName.rawValue), listener)
    }
    
    // remove a listener
    func removeListener(eventName: String, _ listener: EventListener) -> EventManager {
        guard let events = self.events[eventName] else {
            return self
        }
        
        self.events[eventName] = []
            
        for eventListener in events {
            if (eventListener !== listener) {
                self.events[eventName]!.append(eventListener)
            }
        }
        
        return self
    }
    
    // remove given events for a reference
    func removeListener<E: EventTypeProtocol>(eventName: E, _ reference: AnyObject) -> EventManager {
        return self.removeListener(String(eventName.rawValue), reference)
    }
    
    // remove given events for a reference
    func removeListener(eventName: String, _ reference: AnyObject) -> EventManager {
        guard let events = self.events[eventName] else {
            return self
        }
        
        self.events[eventName] = []
        
        for eventListener in events {
            if (eventListener.reference !== reference) {
                self.events[eventName]!.append(eventListener)
            }
        }

        return self
    }
    
    // remove all events for a reference
    func removeListener(reference: AnyObject) -> EventManager {
        for eventName in self.events.keys {
            self.removeListener(eventName, reference)
        }
        
        return self
    }

    // triggers an event
    func trigger<E: EventTypeProtocol>(eventName: E, _ data: Any? = nil) -> Any? {
        return self.trigger(String(eventName.rawValue), data)
    }
    
    // triggers an event
    func trigger(eventName: String, _ data: Any? = nil) -> Any? {
        let event = Event(name: eventName, data: data)
        var lastResult: Any?
        
        // catch all trigger
        for EventListener in self.events["*"]! {
            lastResult = EventListener.raise(event)
        }
        
        // event name trigger
        if (self.events[eventName] != nil) {
            for EventListener in self.events[eventName]! {
                lastResult = EventListener.raise(event)
            }
        }

        return lastResult
    }
}

private class HelperEventManagerProtocol {
    static func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
        if let associated = objc_getAssociatedObject(base, key) as? ValueType {
            return associated
        }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
        
        return associated
    }
    
    static func associateObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}

// https://medium.com/@ttikitu/swift-extensions-can-add-stored-properties-92db66bce6cd#.vur911aus
private var eventManagerBiolerplate: UInt8 = 0 // We still need this boilerplate

protocol EventManagerProtocol {}
extension EventManagerProtocol {
    
    // sharedEventManager
    private func eventManagerInstance(eventManager: EventManagerProtocol) -> EventManager {
        return HelperEventManagerProtocol.associatedObject(eventManager as! AnyObject, key: &eventManagerBiolerplate) {
            return EventManager()
        }
    }

    /***************************** ADD with Function + Event */
     
     // add multiple listeners with function + Event
    func addListeners<E: EventTypeProtocol>(listeners: [E: (event: Event) -> Void], _ reference: AnyObject? = nil) -> EventManager {
        return self.eventManagerInstance(self).addListeners(listeners, reference)
    }
    
    // add an listener
    func addListener<E: EventTypeProtocol>(eventName: E, _ listener: ((event: Event) -> Void), _ reference: AnyObject? = nil) -> EventManager {
        return self.eventManagerInstance(self).addListener(eventName, listener, reference)
    }
    
    // add an listener
    func addListener(eventName: String, _ listener: ((event: Event) -> Void), _ reference: AnyObject? = nil) -> EventManager {
        return self.eventManagerInstance(self).addListener(eventName, listener, reference)
    }
    
    /***************************** ADD with Function */
     
     // add multiple listeners
    func addListeners<E: EventTypeProtocol>(listeners: [E: () -> Void], _ reference: AnyObject? = nil) -> EventManager {
        return self.eventManagerInstance(self).addListeners(listeners, reference)
    }
    
    // add an listener
    func addListener<E: EventTypeProtocol>(eventName: E, _ listener: (() -> Void), _ reference: AnyObject? = nil) -> EventManager {
        return self.eventManagerInstance(self).addListener(eventName, listener, reference)
    }
    
    // add an listener
    func addListener(eventName: String, _ listener: (() -> Void), _ reference: AnyObject? = nil) -> EventManager {
        return self.eventManagerInstance(self).addListener(eventName, listener, reference)
    }
    
    /***************************** ADD */
     
    // add multiple listeners
    func addListeners<E: EventTypeProtocol>(listeners: [E: EventListener]) -> EventManager {
        return self.eventManagerInstance(self).addListeners(listeners)
    }
    
    // add an listener
    func addListener<E: EventTypeProtocol>(eventName: E, _ listener: EventListener) -> EventManager {
        return self.eventManagerInstance(self).addListener(eventName, listener)
    }
    
    // add an listener
    func addListener(eventName: String, _ listener: EventListener) -> EventManager {
        return self.eventManagerInstance(self).addListener(eventName, listener)
    }
    
    /***************************** REMOVE */

    // remove a listener
    func removeListener<E: EventTypeProtocol>(eventName: E, _ listener: EventListener) -> EventManager {
        return self.eventManagerInstance(self).removeListener(eventName, listener)
    }
    
    // remove a listener
    func removeListener(eventName: String, _ listener: EventListener) -> EventManager {
        return self.eventManagerInstance(self).removeListener(eventName, listener)
    }
    // remove given events for a reference
    func removeListener<E: EventTypeProtocol>(eventName: E, _ reference: AnyObject) -> EventManager {
        return self.eventManagerInstance(self).removeListener(eventName, reference)
    }
    
    // remove given events for a reference
    func removeListener(eventName: String, _ reference: AnyObject) -> EventManager {
        return self.eventManagerInstance(self).removeListener(eventName, reference)
    }
    
    // remove all events for a reference
    func removeListener(reference: AnyObject) -> EventManager {
        return self.eventManagerInstance(self).removeListener(reference)
    }
    
    /***************************** TRIGGER */
    
    // triggers an event
    func trigger<E: EventTypeProtocol>(eventName: E, _ data: Any? = nil) -> Any? {
        return self.eventManagerInstance(self).trigger(eventName, data)
    }
    
    // triggers an event
    func trigger(eventName: String, _ data: Any? = nil, async: Bool = false) -> Any? {
        return self.eventManagerInstance(self).trigger(eventName, data)
    }
}