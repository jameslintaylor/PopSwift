//
//  AnimationStyle.swift
//  fizzy
//
//  Created by James Taylor on 2016-04-28.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

import pop

/// An `AnimationSpec` (Spec is short for Specification) encapsulates all properties that defines how an animation should run it's course.
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
