//
//  TimingFunction.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-26.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import UIKit

public enum TimingFunction {
    
    case cool
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case custom(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat)
}

public extension TimingFunction {
    
    init(_ timingFunction: CAMediaTimingFunction) {
        
        switch timingFunction.controlPoints {
        case (0.25, 0.1, 0.25, 1): self = .cool
        case (0, 0, 1, 1): self = .linear
        case (0.42, 0, 1, 1): self = .easeIn
        case (0, 0, 0.58, 1): self = .easeOut
        case (0.42, 0, 0.58, 1): self = .easeInOut
        case let (x1, y1, x2, y2): self = .custom(x1: x1, y1: y1, x2: x2, y2: y2)
        }
    }
}

public extension CAMediaTimingFunction {
    
    convenience init(_ timingFunction: TimingFunction) {
        
        // These values thanks to <http://netcetera.org/camtf-playground.html>
        switch timingFunction {
        case .cool: self.init(controlPoints: 0.25, 0.1, 0.25, 1)
        case .linear: self.init(controlPoints: 0, 0, 1, 1)
        case .easeIn: self.init(controlPoints: 0.42, 0, 1, 1)
        case .easeOut: self.init(controlPoints: 0, 0, 0.58, 1)
        case .easeInOut: self.init(controlPoints: 0.42, 0, 0.58, 1)
        case let .custom(x1, y1, x2, y2): self.init(controlPoints: Float(x1), Float(y1), Float(x2), Float(y2))
        }
    }
}

public extension CAMediaTimingFunction {
    
    /// Return the control points of the timing function.
    var controlPoints: (x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        
        var cps = [Float](count: 4, repeatedValue: 0)
        getControlPointAtIndex(0, values: &cps[0])
        getControlPointAtIndex(1, values: &cps[1])
        getControlPointAtIndex(2, values: &cps[2])
        getControlPointAtIndex(3, values: &cps[3])
        
        let asCGFloats = cps.map(CGFloat.init)
        return (asCGFloats[0], asCGFloats[1], asCGFloats[2], asCGFloats[3])
    }
}
