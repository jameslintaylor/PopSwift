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
    
    /// Animates the receiver for `duration` to a final value following
    /// a timing function (default is `TimingFunction.Default`)
    func animate(toValue toValue: CGFloat, duration: CFTimeInterval, timingFunction: TimingFunction = .Default, onApply: (() -> ())? = nil, onComplete: ((completed: Bool) -> ())? = nil) {
        
        // guard let object = object else { return }
        
        let animation = POPBasicAnimation()
        animation.property = property
        animation.toValue = toValue
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(timingFunction)
        
        animation.animationDidApplyBlock = { animation in
            onApply?()
        }
        
        animation.completionBlock = { animation, completed in
            onComplete?(completed: completed)
        }
        
        // TODO: - Generate a new key
        // work out some good logic for this, otherwise include in parameter.
        let key = "/"
        
        object.pop_addAnimation(animation, forKey: key)
    }
    
    /// Animates the receiver to a final value based on a spring
    /// and an initial velocity.
    func animate(toValue toValue: CGFloat, initialVelocity: CGFloat = 0, springBounciness: CGFloat = 4, springSpeed: CGFloat = 12, onApply: (() -> ())? = nil, onComplete: ((completed: Bool) -> ())? = nil) {
        
        // guard let object = object else { return }
        
        let animation = POPSpringAnimation()
        animation.property = property
        animation.toValue = toValue
        animation.velocity = initialVelocity
        animation.springBounciness = springBounciness
        animation.springSpeed = springSpeed
        
        animation.animationDidApplyBlock = { animation in
            onApply?()
        }
        
        animation.completionBlock = { (animation, completed) in
            onComplete?(completed: completed)
        }
        
        // Generate a new key
        let key = "/"
        
        object.pop_addAnimation(animation, forKey: key)
    }
    
    /// Animates the receiver by giving it a initial velocity and
    /// letting it decay based on `damping`.
    func animate(initialVelocity initialVelocity: CGFloat, damping: CGFloat = 0.998, onApply: (() -> ())? = nil, onComplete: ((completed: Bool) -> ())? = nil) {
        
        // guard let object = object else { return }
        
        let animation = POPDecayAnimation()
        animation.property = property
        animation.velocity = initialVelocity
        animation.deceleration = damping
        
        animation.animationDidApplyBlock = { animation in
            onApply?()
        }
        
        animation.completionBlock = { (animation, completed) in
            onComplete?(completed: completed)
        }
        
        // Generate a new key
        let key = "/"
        
        object.pop_addAnimation(animation, forKey: key)
    }
}
