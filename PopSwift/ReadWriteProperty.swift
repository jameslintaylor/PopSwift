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

/// An structure defining an animatable property of an object.
public struct ReadWriteProperty<Object: NSObject> {
    
    // PROBABLY SHOULD BE WEAK WITH DECLARATION
    // private(set) weak var object: Object? *Crashing in Xcode 7.3.1*
    //
    /// The object owner of the property.
    public unowned let owner: Object
    
    // The read/write access specifier for the property.
    private let access: ReadWriteAccess<Object>
}

public struct ReadWriteAccess<Object: NSObject> {
    
    // 🙌
    public typealias PropertyRead = (Object, inout CGFloat) -> ()
    public typealias PropertyWrite = (Object, CGFloat) -> ()
    
    private var pop_read: POPReadBlock = { _ in }
    private var pop_write: POPWriteBlock = { _ in }
    
    public mutating func read(_ readBlock: PropertyRead) {
        pop_read = { readBlock($0 as! Object, &$1[0]) }
    }
    
    public mutating func write(_ writeBlock: PropertyWrite) {
        pop_write = { writeBlock($0 as! Object, $1[0]) }
    }
}

public extension ReadWriteProperty {
    
    /// Create a new `ReadWriteProperty` for the given owner.
    init(in owner: Object, readWrite: (inout ReadWriteAccess<Object>) -> ()) {
        
        self.owner = owner
        
        // Get the read and write blocks from the supplied closure.
        var access = ReadWriteAccess<Object>()
        readWrite(&access)
        self.access = access
    }
}

// Animatable

extension ReadWriteProperty: Animatable {
    
    public var property: POPAnimatableProperty {
        
        return POPAnimatableProperty.propertyWithName("") {
            $0.readBlock = self.access.pop_read
            $0.writeBlock = self.access.pop_write
            $0.threshold = 0.01
            } as! POPAnimatableProperty
    }
    
    public var object: NSObject {
        return owner
    }
}
