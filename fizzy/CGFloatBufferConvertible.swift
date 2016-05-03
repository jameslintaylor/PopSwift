//
//  CGFloatBufferConvertible.swift
//  fizzy
//
//  Created by James Taylor on 2016-05-02.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

/// Conforming types can be converted to and from an array of `CGFloat`s.
public protocol CGFloatArrayConvertible {
    
    /// The number of `CGFloat`s necessary to represent self.
    /// This value should identical to `asCGFloats.count` and the count
    /// of the `cgFloats` array passed in `init(cgFloats:)`.
    static var cgFloatCount: Int { get }
    
    init(cgFloats: [CGFloat])
    
    /// `Self` represented as an array of `CGFloat`s.
    var asCGFloats: [CGFloat] { get }
}

extension CGFloat: CGFloatArrayConvertible {
    
    public static var cgFloatCount: Int { return 1 }
    
    public init(cgFloats: [CGFloat]) {
        self = cgFloats[0]
    }
    
    public var asCGFloats: [CGFloat] {
        return [self]
    }
}
