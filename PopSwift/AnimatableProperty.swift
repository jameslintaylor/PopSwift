//
//  AnimatableProperty.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-26.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import UIKit
import pop

// 💩
private typealias POPReadBlock = (AnyObject!, UnsafeMutablePointer<CGFloat>) -> ()
private typealias POPWriteBlock = (AnyObject!, UnsafePointer<CGFloat>) -> ()
private typealias POPInitializer = (POPMutableAnimatableProperty!) -> ()
private typealias POPCompletionBlock = (POPAnimation!, Bool) -> ()

/// An structure defining an animatable property of an object.
public struct AnimatableProperty<Object: NSObject> {
    
    // 🙌
    public typealias PropertyRead = (Object, inout CGFloat) -> ()
    public typealias PropertyWrite = (Object, CGFloat) -> ()
    
    /// The object owner of the property.
    public let object: Object
    
    /// The name associated with the property.
    public var name: String { return property.name }
    
    /// The threshold of the property.
    public var threshold: CGFloat { return property.threshold }
    
    // The backing POPAnimatableProperty object.
    private let property: POPAnimatableProperty
}

// + Equatable
extension AnimatableProperty: Equatable {}
public func == <Object where Object: Equatable> (lhs: AnimatableProperty<Object>, rhs: AnimatableProperty<Object>) -> Bool {
    return (lhs.object == rhs.object) && (lhs.name == rhs.name) && (lhs.threshold == rhs.threshold) && (lhs.property == rhs.property)
}

// + Initializers
public extension AnimatableProperty {
    
    /// Initialize a new instance of `AnimatableProperty` with
    /// the property's housing `object`, and appropriate `read`
    /// and `write` closures.
    init(object: Object, read: PropertyRead, write: PropertyWrite, name: String = "", threshold: CGFloat = 0.01) {
        
        self.object = object
        
        // Cast the PropertyRead block to a POPReadBlock
        let readBlock: POPReadBlock = { read($0 as! Object, &$1[0]) }
        
        // Cast the PropertyWrite block to a POPWriteBlock
        let writeBlock: POPWriteBlock = { write($0 as! Object, $1[0]) }
        
        // Build the backing POPAnimatableProperty
        property = POPAnimatableProperty.propertyWithName(name) {
            $0.readBlock = readBlock
            $0.writeBlock = writeBlock
            $0.threshold = threshold
        } as! POPAnimatableProperty
    }
}

// MARK: - Animations

public extension AnimatableProperty {
    
    /// Animates the receiver for `duration` to a final value following
    /// a timing function (default is `TimingFunction.Default`)
    func animateTo(toValue: CGFloat, duration: CFTimeInterval, timingFunction: TimingFunction = .Default, key: String = "", completionBlock: (BasicAnimationState -> ())? = nil) {
        
        let animation = POPBasicAnimation()
        animation.property = property
        animation.toValue = toValue
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(timingFunction)
        
        // Capture state on completion
        if let completionBlock = completionBlock {
            
            animation.completionBlock = { (animation, completed) in
                
                let state = BasicAnimationState(animation: animation, completed: completed)!
                completionBlock(state)
            }
        }
    
        object.pop_addAnimation(animation, forKey: key)
    }
    
    /// Animates the receiver to a final value based on a spring 
    /// and an initial velocity.
    func animateTo(toValue: CGFloat, initialVelocity: CGFloat, springBounciness: CGFloat, springSpeed: CGFloat, key: String = "default", completionBlock: (SpringAnimationState -> ())? = nil) {
        
        let animation = POPSpringAnimation()
        animation.property = property
        animation.toValue = toValue
        animation.springBounciness = springBounciness
        animation.springSpeed = springSpeed
        
        // Capture state on completion
        if let completionBlock = completionBlock {
            
            animation.completionBlock = { (animation, completed) in
             
                let state = SpringAnimationState(animation: animation, completed: completed)!
                completionBlock(state)
            }
        }
        
        object.pop_addAnimation(animation, forKey: key)
    }
    
    /// Animates the receiver by giving it a initial velocity and
    /// letting it decay based on `damping`.
    func animateWith(initialVelocity: CGFloat, damping: CGFloat = 0.998, key: String = "default", completionBlock: (DecayAnimationState -> ())? = nil) {
        
        let animation = POPDecayAnimation()
        animation.property = property
        animation.velocity = initialVelocity
        animation.deceleration = damping
        
        if let completionBlock = completionBlock {
            
            animation.completionBlock = { (animation, completed) in
                
                let state = DecayAnimationState(animation: animation, completed: completed)!
                completionBlock(state)
            }
        }
        
        object.pop_addAnimation(animation, forKey: key)
    }
}
