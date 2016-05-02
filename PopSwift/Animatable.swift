//
//  Animatable.swift
//  fizzy
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
    
    /// Creates and returns a new animation for the given spec. Note that the returned animation
    /// is not started automatically and will wait until it's `start()` method is called.
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

// Convenience methods

public extension Animatable {
    
    /// Animates `self` to the given `toValue` along a generic curve. Under the hood, this method 
    /// is just convenience around calling `newAnimation(.generic(...)).start()`.
    func animateTo(toValue: CGFloat, duration: CFTimeInterval = 1) {

        newAnimation(AnimationSpec.generic(toValue: toValue, duration: duration))
            .start()
    }
    
    /// Animates `self` with the given `AnimationSpec`. Under the hood, this method is just convenience 
    /// around calling `newAnimation(_:).start()`
    func animateAs(spec: AnimationSpec) {
        
        newAnimation(spec)
            .start()
    }
    
}

// Helpers

private extension AnimationSpec {
    
    func popAnimationWithProperty(property: POPAnimatableProperty) -> POPAnimation {
        
        switch self {
            
        case let .basic(toValue, duration, timingFunction):
            let animation = POPBasicAnimation()
            animation.property = property
            animation.toValue = toValue
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(timingFunction)
            return animation
            
        case let .spring(toValue, initialVelocity, springBounciness, springSpeed):
            let animation = POPSpringAnimation()
            animation.property = property
            animation.toValue = toValue
            animation.velocity = initialVelocity
            animation.springBounciness = springBounciness
            animation.springSpeed = springSpeed
            return animation
            
        case let .decay(initialVelocity, damping):
            let animation = POPDecayAnimation()
            animation.property = property
            animation.velocity = initialVelocity
            animation.deceleration = damping
            return animation
        }
    }
}
