//
//  BasicAnimationState.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-26.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import UIKit
import pop

/// Structure encapsulating propertes related to the 
/// state of a basic animation at an instant in time.
public struct BasicAnimationState {
    
    public let duration: CFTimeInterval
    public let timingFunction: TimingFunction

    public let key: String
    public let completed: Bool
}

// + Equatable
extension BasicAnimationState: Equatable {}
public func == (lhs: BasicAnimationState, rhs: BasicAnimationState) -> Bool {
    return
        (lhs.duration == rhs.duration) &&
        (lhs.timingFunction == rhs.timingFunction) &&
        (lhs.key == rhs.key) &&
        (lhs.completed == rhs.completed)
}


// + Initializers
public extension BasicAnimationState {

    init?(animation: POPAnimation, key: String, completed: Bool) {
        guard let basicAnimation = animation as? POPBasicAnimation else { return nil }
        
        self.duration = basicAnimation.duration
        self.timingFunction = TimingFunction(basicAnimation.timingFunction)
        
        self.key = key
        self.completed = completed
    }
}
