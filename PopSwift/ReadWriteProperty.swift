//
//  AnimatableProperty.swift
//  Zeno
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
public struct ReadWriteProperty<Object: NSObject> {
    
    /// The object owner of the property.
    public unowned let owner: Object
    
    // Read and write access specifiers
    private var popRead: POPRead = { _ in }
    private var popWrite: POPWrite = { _ in }
    
    /// Create a new `ReadWriteProperty` for the given owner.
    public init(in owner: Object) {
        self.owner = owner
    }
}

public extension ReadWriteProperty {
    
    // 🙌
    public typealias PropertyRead = (Object, inout CGFloat) -> ()
    public typealias PropertyWrite = (Object, CGFloat) -> ()
    
    func read(read: PropertyRead) -> ReadWriteProperty<Object> {

        var copy = self
        copy.popRead = { read($0 as! Object, &$1[0]) }
        return copy
    }
    
    func write(write: PropertyWrite) -> ReadWriteProperty<Object> {
        
        var copy = self
        copy.popWrite = { write($0 as! Object, $1[0]) }
        return copy
    }
}

// Animatable

extension ReadWriteProperty: Animatable {
    
    public var property: POPAnimatableProperty {
        
        return POPAnimatableProperty.propertyWithName("") {
            $0.readBlock = self.popRead
            $0.writeBlock = self.popWrite
            $0.threshold = 0.01
            } as! POPAnimatableProperty
    }
    
    public var object: NSObject {
        return owner
    }
}
