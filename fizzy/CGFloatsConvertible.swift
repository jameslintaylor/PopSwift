//
//  CGFloatsConvertible.swift
//  fizzy
//
//  Created by James Taylor on 2016-05-03.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

/// Conforming types can be converted to and from an array of `CGFloat`s.
public protocol CGFloatsConvertible {
    
    /// The number of `CGFloat`s necessary to represent self.
    /// This value should identical to `asCGFloats.count` and the count
    /// of the `cgFloats` array passed in `init(cgFloats:)`.
    static var cgFloatCount: Int { get }
    
    init(cgFloats: [CGFloat])
    
    /// `Self` represented as an array of `CGFloat`s.
    var asCGFloats: [CGFloat] { get }
}

// CoreGraphics implementations

extension CGFloat: CGFloatsConvertible {
    
    public static var cgFloatCount: Int { return 1 }
    
    public init(cgFloats: [CGFloat]) {
        self = cgFloats[0]
    }
    
    public var asCGFloats: [CGFloat] {
        return [self]
    }
}

extension CGPoint: CGFloatsConvertible {
    
    public static var cgFloatCount: Int { return 2 }
    
    public init(cgFloats: [CGFloat]) {
        x = cgFloats[0]
        y = cgFloats[1]
    }
    
    public var asCGFloats: [CGFloat] {
        return [x, y]
    }
}

extension CGSize: CGFloatsConvertible {
    
    public static var cgFloatCount: Int { return 2 }
    
    public init(cgFloats: [CGFloat]) {
        width = cgFloats[0]
        height = cgFloats[1]
    }
    
    public var asCGFloats: [CGFloat] {
        return [width, height]
    }
}

extension CGRect: CGFloatsConvertible {
    
    public static var cgFloatCount: Int { return CGPoint.cgFloatCount + CGSize.cgFloatCount }
    
    public init(cgFloats: [CGFloat]) {
        origin = CGPoint.init(cgFloats: [cgFloats[0], cgFloats[1]])
        size = CGSize.init(cgFloats: [cgFloats[2], cgFloats[3]])
    }
    
    public var asCGFloats: [CGFloat] {
        return origin.asCGFloats + size.asCGFloats
    }
}
