//
//  TimingFunction.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-26.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import UIKit

public enum TimingFunction {
    case Default
    case Linear
    case EaseIn
    case EaseOut
    case EaseInOut
    case Custom(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat)
}

// + Equatable
extension TimingFunction: Equatable {}
public func == (lhs: TimingFunction, rhs: TimingFunction) -> Bool {
    switch (lhs, rhs) {
    case (.Default, .Default): return true
    case (.Linear, .Linear): return true
    case (.EaseIn, .EaseIn): return true
    case (.EaseOut, .EaseOut): return true
    case (.EaseInOut, .EaseInOut): return true
    case let (.Custom(lhsControlPoints), .Custom(rhsControlPoints)) where lhsControlPoints == rhsControlPoints: return true
    default: return false
    }
}

public extension TimingFunction {
    
    init(_ timingFunction: CAMediaTimingFunction) {
        
        switch timingFunction.controlPoints {
        case let controlPoints where controlPoints == (0.25, 0.1, 0.25, 1): self = .Default
        case let controlPoints where controlPoints == (0, 0, 1, 1): self = .Linear
        case let controlPoints where controlPoints == (0.42, 0, 1, 1): self = .EaseIn
        case let controlPoints where controlPoints == (0, 0, 0.58, 1): self = .EaseOut
        case let controlPoints where controlPoints == (0.42, 0, 0.58, 1): self = .EaseInOut
        case let (x1, y1, x2, y2): self = .Custom(x1: x1, y1: y1, x2: x2, y2: y2)
        }
    }
}

public extension CAMediaTimingFunction {
    
    convenience init(_ timingFunction: TimingFunction) {
        
        // These values thanks to <http://netcetera.org/camtf-playground.html>
        switch timingFunction {
        case .Default: self.init(controlPoints: 0.25, 0.1, 0.25, 1)
        case .Linear: self.init(controlPoints: 0, 0, 1, 1)
        case .EaseIn: self.init(controlPoints: 0.42, 0, 1, 1)
        case .EaseOut: self.init(controlPoints: 0, 0, 0.58, 1)
        case .EaseInOut: self.init(controlPoints: 0.42, 0, 0.58, 1)
        case let .Custom(x1, y1, x2, y2): self.init(controlPoints: Float(x1), Float(y1), Float(x2), Float(y2))
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
