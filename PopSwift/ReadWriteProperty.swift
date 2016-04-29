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
private typealias POPReadBlock = (AnyObject!, UnsafeMutablePointer<CGFloat>) -> ()
private typealias POPWriteBlock = (AnyObject!, UnsafePointer<CGFloat>) -> ()

// Need this class to encapsulate read and write access specifiers for 
// the ReadWriteProperty while keeping the toRead(_:) and toWrite(_:) functions
// non-mutating and therefore Chainable...
private class ReadWriteAccess {
    var read: POPReadBlock = { _ in }
    var write: POPWriteBlock = { _ in }
}

/// An structure defining an animatable property of an object.
public struct ReadWriteProperty<Object: NSObject> {
    
    // PROBABLY SHOULD BE WEAK WITH DECLARATION
    // private(set) weak var object: Object? *Crashing in Xcode 7.3.1*
    //
    /// The object owner of the property.
    public unowned let owner: Object
    
    // The access specifier container for the property.
    private let access = ReadWriteAccess()
    
    /// Create a new `ReadWriteProperty` for the given owner.
    public init(in owner: Object) {
        self.owner = owner
    }
}

public extension ReadWriteProperty {
    
    // 🙌
    public typealias PropertyRead = (Object, inout CGFloat) -> ()
    public typealias PropertyWrite = (Object, CGFloat) -> ()
    
    func toRead(toRead: PropertyRead) -> ReadWriteProperty<Object> {
        access.read = { toRead($0 as! Object, &$1[0]) }
        return self
    }
    
    func toWrite(toWrite: PropertyWrite) -> ReadWriteProperty<Object> {
        access.write = { toWrite($0 as! Object, $1[0]) }
        return self
    }
}

// Animatable

extension ReadWriteProperty: Animatable {
    
    public var property: POPAnimatableProperty {
        
        return POPAnimatableProperty.propertyWithName("") {
            $0.readBlock = self.access.read
            $0.writeBlock = self.access.write
            $0.threshold = 0.01
            } as! POPAnimatableProperty
    }
    
    public var object: NSObject {
        return owner
    }
}
