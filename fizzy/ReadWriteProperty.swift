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
public struct ReadWriteProperty<Object: NSObject, Property: CGFloatArrayConvertible> {
    
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
    
    // 🙌
    public typealias PropertyRead = (Object) -> Property
    public typealias PropertyWrite = (Object, Property) -> ()
    
    func read(read: PropertyRead) -> ReadWriteProperty<Object, Property> {

        var copy = self
        copy.popRead = { any, bufferStart in
            let property = read(any as! Object)
            let cgFloats = property.asCGFloats
            cgFloats.enumerate().forEach { bufferStart[$0] = $1 }
        }
        
        return copy
    }
    
    func write(write: PropertyWrite) -> ReadWriteProperty<Object, Property> {
        
        var copy = self
        copy.popWrite = { any, bufferStart in
            let cgFloats = Array(pointer: bufferStart, count: Property.cgFloatCount)
            let property = Property.init(cgFloats: cgFloats)
            write(any as! Object, property)
        }
        
        return copy
    }
}

// Animatable

extension ReadWriteProperty: Animatable {
    
    public var property: POPAnimatableProperty {
        
        return POPAnimatableProperty.propertyWithName(name) {
            $0.readBlock = self.popRead
            $0.writeBlock = self.popWrite
            $0.threshold = 0.01
        } as! POPAnimatableProperty
    }
    
    public var object: NSObject {
        return owner
    }
}

// Helpers

private extension Array {
    
    init(pointer: UnsafePointer<Element>, count: Int) {
        let buffer = UnsafeBufferPointer(start: pointer, count: count)
        self.init(buffer)
    }
}
