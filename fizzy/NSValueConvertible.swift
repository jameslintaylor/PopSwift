//
//  NSValueConvertible.swift
//  fizzy
//
//  Created by James Taylor on 2016-05-02.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

/// Conforming types can be converted to and from an `NSValue`.
public protocol NSValueConvertible {
    
    init(nsValue: NSValue)
    
    /// `Self` represented as an `NSValue`.
    var asNSValue: NSValue { get }
}

// CoreGraphics implementations

extension CGFloat: NSValueConvertible {
    public init(nsValue: NSValue) { self = nsValue as! CGFloat }
    public var asNSValue: NSValue { return self }
}

extension CGPoint: NSValueConvertible {
    public init(nsValue: NSValue) { self = nsValue.CGPointValue() }
    public var asNSValue: NSValue { return NSValue(CGPoint: self) }
}

extension CGSize: NSValueConvertible {
    public init(nsValue: NSValue) { self = nsValue.CGSizeValue() }
    public var asNSValue: NSValue { return NSValue(CGSize: self) }
}

extension CGRect: NSValueConvertible {
    public init(nsValue: NSValue) { self = nsValue.CGRectValue() }
    public var asNSValue: NSValue { return NSValue(CGRect: self) }
}
