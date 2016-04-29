//
//  AnimationStyle.swift
//  PopSwift
//
//  Created by James Taylor on 2016-04-28.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

import pop

public enum AnimationSpec {
    
    /// A basic animation spec, following a fixed curve and with a predefined duration.
    case basic(toValue: CGFloat, duration: CFTimeInterval, timingFunction: TimingFunction)
    
    /// A super awesome springy animation spec with parameters for tweaking behaviour of the spring.
    case spring(toValue: CGFloat, initialVelocity: CGFloat, springBounciness: CGFloat, springSpeed: CGFloat)
    
    /// A decaying animation spec with an initial velocity parameter as well as a damping parameter for adjusting the speed of decay.
    case decay(initialVelocity: CGFloat, damping: CGFloat)
}
    
public extension AnimationSpec {
    
    /// Creates a generic `basic` spec using default value `cool` for `timingFunction`.
    static func generic(toValue toValue: CGFloat, duration: CFTimeInterval) -> AnimationSpec {
        
        return .basic(toValue: toValue,
                      duration: duration,
                      timingFunction: .cool)
    }
    
    /// Creates a generic `spring` spec using default values for 12 and 4 for `springBounciness` and `springSpeed` respectively.
    static func genericSpring(toValue toValue: CGFloat, initialVelocity: CGFloat) -> AnimationSpec {
        
        return .spring(toValue: toValue,
                       initialVelocity: initialVelocity,
                       springBounciness: 12,
                       springSpeed: 4)
    }
    
    /// Creates a generic decay spec using default value 0.998 for `damping`.
    static func genericDecay(initialVelocity initialVelocity: CGFloat) -> AnimationSpec {
    
        return .decay(initialVelocity: initialVelocity,
                      damping: 0.998)
    }
}

extension AnimationSpec {
    
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
