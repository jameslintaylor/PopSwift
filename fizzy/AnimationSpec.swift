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
public enum AnimationSpec<Value: NSValueConvertible> {
    
    /// A basic animation spec, following a fixed curve and with a predefined duration.
    case basic(toValue: Value, duration: CFTimeInterval, curve: AnimationCurve)
    
    /// A super awesome springy animation spec with parameters for tweaking behaviour of the spring.
    case spring(toValue: Value, initialVelocity: Value, springBounciness: CGFloat, springSpeed: CGFloat)
    
    /// A decaying animation spec with an initial velocity parameter as well as a damping parameter for adjusting the speed of decay.
    case decay(initialVelocity: Value, damping: CGFloat)
}
    
public extension AnimationSpec {
    
    /// Creates a generic `basic` spec using default value `cool` for `curve`.
    static func generic(toValue toValue: Value, duration: CFTimeInterval) -> AnimationSpec {
        
        return .basic(toValue: toValue,
                      duration: duration,
                      curve: .cool)
    }
    
    /// Creates a generic `spring` spec using default values for 12 and 4 for `springBounciness` and `springSpeed` respectively.
    static func genericSpring(toValue toValue: Value, initialVelocity: Value) -> AnimationSpec {
        
        return .spring(toValue: toValue,
                       initialVelocity: initialVelocity,
                       springBounciness: 12,
                       springSpeed: 4)
    }
    
    /// Creates a generic decay spec using default value 0.998 for `damping`.
    static func genericDecay(initialVelocity initialVelocity: Value) -> AnimationSpec {
    
        return .decay(initialVelocity: initialVelocity,
                      damping: 0.998)
    }
}
