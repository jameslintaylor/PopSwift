//
//  DecayAnimationState.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-26.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import UIKit
import pop

/// Structure encapsulating propertes related to the
/// state of a decay animation at an instant in time.
public struct DecayAnimationState {
    
    public let velocity: CGFloat
    public let originalVelocity: CGFloat
    
    public let key: String
    public let completed: Bool
}

// + Equatable
extension DecayAnimationState: Equatable {}
public func == (lhs: DecayAnimationState, rhs: DecayAnimationState) -> Bool {
    return
        (lhs.velocity == rhs.velocity) &&
        (lhs.originalVelocity == rhs.originalVelocity) &&
        (lhs.key == rhs.key) &&
        (lhs.completed == rhs.completed)
}

// + Initializers
public extension DecayAnimationState {
    
    init?(animation: POPAnimation, key: String, completed: Bool) {
        
        guard
            let decayAnimation = animation as? POPDecayAnimation,
            let velocity = decayAnimation.velocity as? CGFloat,
            let originalVelocity = decayAnimation.originalVelocity as? CGFloat else { return nil }
        
        self.velocity = velocity
        self.originalVelocity = originalVelocity
        
        self.key = key
        self.completed = completed
    }
}
