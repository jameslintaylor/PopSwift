//
//  POPAnimatable.swift
//  fizzy
//
//  Created by James Taylor on 2016-05-03.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

// This protocol solely requires conformance to both `NSValueConvertible` and `CGFloatsConvertible`. Adopters of this protocol can be animated by pop.
public protocol POPAnimatable: NSValueConvertible, CGFloatsConvertible {}

extension CGFloat: POPAnimatable {}
extension CGPoint: POPAnimatable {}
extension CGSize: POPAnimatable {}
extension CGRect: POPAnimatable {}
