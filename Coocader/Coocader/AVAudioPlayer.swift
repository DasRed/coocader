//
//  AVAudioPlayer.swift
//  Coocader
//
//  Created by Marco Starker on 15.02.16.
//  Copyright © 2016 Marco Starker. All rights reserved.
//

import Foundation
import AVFoundation

extension AVAudioPlayer {
    
    /// fadeIn the player
    /// - overTime in secounds
    func fadeIn(overTime time: Float, completion: () -> Void) -> AVAudioPlayer {
        return self.fade(toVolume: 1.0, overTime: time, completion: completion)
    }

    // fadeOut the player
    /// - overTime in secounds
    func fadeOut(overTime time: Float, completion: () -> Void) -> AVAudioPlayer {
        return self.fade(toVolume: 0.0, overTime: time, completion: completion)
    }

    /// fade a player
    /// - overTime in secounds
    func fade(toVolume endVolume: Float, overTime time: Float, completion: () -> Void) -> AVAudioPlayer {
        // Update the volume every 1/100 of a second
        let fadeSteps : Int = Int(time) * 100
        // Work out how much time each step will take
        let timePerStep : Float = 1 / 100.0

        let startVolume = self.volume

        // Schedule a number of volume changes
        for step in 0...fadeSteps {
            let delayInSeconds : Float = Float(step) * timePerStep

            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Float(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue()) {
                let fraction = (Float(step) / Float(fadeSteps))

                self.volume = startVolume + (endVolume - startVolume) * fraction

                if (self.volume == endVolume) {
                    completion()
                }
            }
        }
        
        return self
    }
}