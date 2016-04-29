//
//  Animatable.swift
//  PopSwift
//
//  Created by James Taylor on 2016-04-23.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation
import pop

public protocol Animatable {
    
    var object: NSObject { get }
    var property: POPAnimatableProperty { get }
}

public extension Animatable {
    
    func newAnimation(spec: AnimationSpec) -> Animation {
        
        // Generate a UUID to use as the key
        let key = NSUUID().UUIDString
        
        // Create the PopAnimation
        let animation = spec.popAnimationWithProperty(property)
        
        // return the Animation object wrapping the created PopAnimation
        return Animation(popAnimation: animation,
            toStart: { self.object.pop_addAnimation(animation, forKey: key) },
            toCancel: {  self.object.pop_removeAnimationForKey(key) }
        )
    }
}
