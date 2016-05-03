//
//  AnimatableProperty.swift
//  fizzy
//
//  Created by James Taylor on 2016-02-26.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation
import UIKit

import pop

// 💩
private typealias POPRead = (AnyObject!, UnsafeMutablePointer<CGFloat>) -> ()
private typealias POPWrite = (AnyObject!, UnsafePointer<CGFloat>) -> ()

/// An structure defining an animatable property of an object.
public struct ReadWriteProperty<Object: NSObject, Value: POPAnimatable> {
    
    /// The name of the property
    public let name: String?
    
    /// The object owner of the property.
    public unowned let owner: Object
    
    // Read and write access specifiers
    private var popRead: POPRead = { _ in }
    private var popWrite: POPWrite = { _ in }
    
    /// Create a new `ReadWriteProperty` for the given owner.
    public init(name: String? = nil, in owner: Object) {
        self.name = name
        self.owner = owner
    }
}

public extension ReadWriteProperty {
    
    /// Read and return the property from the given object.
    public typealias PropertyRead = (Object) -> Value
    
    /// Write `newValue` into the given `to` object.
    public typealias PropertyWrite = (newValue: Value, to: Object) -> ()
    
    /// Read and return the property from the given object.
    func read(read: PropertyRead) -> ReadWriteProperty<Object, Value> {

        var copy = self
        copy.popRead = { any, bufferStart in
            let property = read(any as! Object)
            let cgFloats = property.asCGFloats
            cgFloats.copyTo(bufferStart)
        }
        
        return copy
    }
    
    /// Write `newValue` into the given `to` object.
    func write(write: PropertyWrite) -> ReadWriteProperty<Object, Value> {
        
        var copy = self
        copy.popWrite = { any, bufferStart in
            let cgFloats = Array(pointer: bufferStart, count: Value.cgFloatCount)
            let property = Value.init(cgFloats: cgFloats)
            write(newValue: property, to: any as! Object)
        }
        
        return copy
    }
}

// Animatable

public extension ReadWriteProperty {
    
    /// Creates and returns a new animation for the given spec. Note that the returned animation
    /// is not started automatically and will wait until it's `start()` method is called.
    func newAnimation(spec: AnimationSpec<Value>) -> Animation {
        
        // Generate a UUID to use as the key
        let key = NSUUID().UUIDString
        
        // Create the POPAnimatableProperty
        let popProperty = POPAnimatableProperty.propertyWithName(name) {
            $0.readBlock = self.popRead
            $0.writeBlock = self.popWrite
            $0.threshold = 0.01
        } as! POPAnimatableProperty
        
        // Create the POPAnimation
        let animation = spec.popAnimationWithProperty(popProperty)
        
        // return the Animation object wrapping the created POPAnimation
        return Animation(popAnimation: animation,
                         toStart: { self.owner.pop_addAnimation(animation, forKey: key) },
                         toCancel: { self.owner.pop_removeAnimationForKey(key) }
        )
    }
    
    /// Animates `self` to the given `toValue` along a generic curve. Under the hood, this method
    /// is just convenience around calling `newAnimation(.generic(...)).start()`.
    func animateTo(toValue: Value, duration: CFTimeInterval = 1) {
        
        newAnimation(AnimationSpec.generic(toValue: toValue, duration: duration))
            .start()
    }
    
    /// Animates `self` with the given `AnimationSpec`. Under the hood, this method is just convenience
    /// around calling `newAnimation(_:).start()`
    func animateAs(spec: AnimationSpec<Value>) {
        
        newAnimation(spec)
            .start()
    }
    
}

// Helpers

private extension AnimationSpec {
    
    func popAnimationWithProperty(property: POPAnimatableProperty) -> POPAnimation {
        
        switch self {
            
        case let .basic(toValue, duration, timingFunction):
            let animation = POPBasicAnimation()
            animation.property = property
            animation.toValue = toValue.asNSValue
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(timingFunction)
            return animation
            
        case let .spring(toValue, initialVelocity, springBounciness, springSpeed):
            let animation = POPSpringAnimation()
            animation.property = property
            animation.toValue = toValue.asNSValue
            animation.velocity = initialVelocity.asNSValue
            animation.springBounciness = springBounciness
            animation.springSpeed = springSpeed
            return animation
            
        case let .decay(initialVelocity, damping):
            let animation = POPDecayAnimation()
            animation.property = property
            animation.velocity = initialVelocity.asNSValue
            animation.deceleration = damping
            return animation
        }
    }
}

private extension Array {
    
    init(pointer: UnsafePointer<Element>, count: Int) {
        let buffer = UnsafeBufferPointer(start: pointer, count: count)
        self.init(buffer)
    }
    
    func copyTo(pointer: UnsafeMutablePointer<Element>) {
        enumerate().forEach { pointer[$0] = $1 }
    }
}
