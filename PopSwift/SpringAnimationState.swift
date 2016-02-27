//
//  SpringAnimationState.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-26.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import UIKit
import pop

/// Structure encapsulating propertes related to the
/// state of a spring animation at an instant in time.
public struct SpringAnimationState {
  
    public let velocity: CGFloat
    public let springBounciness: CGFloat
    public let springSpeed: CGFloat
    
    public let completed: Bool
}

// + Equatable
extension SpringAnimationState: Equatable {}
public func == (lhs: SpringAnimationState, rhs: SpringAnimationState) -> Bool {
    return (lhs.completed == rhs.completed) && (lhs.velocity == rhs.velocity) && (lhs.springBounciness == rhs.springBounciness) && (lhs.springSpeed == rhs.springSpeed) && (lhs.completed == rhs.completed)
}

// + Initializers
public extension SpringAnimationState {
    
    init?(animation: POPAnimation, completed: Bool) {
        guard
            let springAnimation = animation as? POPSpringAnimation,
            let velocity = springAnimation.velocity as? CGFloat else { return nil }
        
        self.velocity = velocity
        self.springBounciness = springAnimation.springBounciness
        self.springSpeed = springAnimation.springSpeed
        
        self.completed = completed
    }
}
