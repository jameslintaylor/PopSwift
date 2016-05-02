//
//  Animation.swift
//  PopSwift
//
//  Created by James Taylor on 2016-04-28.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

import pop

/// Wrapper around PopAnimation exposing some functions
/// promoting chaining with trailing closure syntax at the call site.
public struct Animation {
    
    public let wrapped: POPAnimation
    
    private let toStart: () -> ()
    private let toCancel: () -> ()
    
    init(popAnimation: POPAnimation, toStart: () -> (), toCancel: () -> ()) {
        self.wrapped = popAnimation
        self.toStart = toStart
        self.toCancel = toCancel
    }
}

public extension Animation {
    
    func onApply(onApply: () -> ()) -> Animation {
        wrapped.animationDidApplyBlock = { _ in onApply() }
        return self
    }
    
    func onComplete(onComplete: () -> ()) -> Animation {
        wrapped.completionBlock = { _ in onComplete() }
        return self
    }
    
    func onReachedToValue(closure: () -> ()) -> Animation {
        wrapped.animationDidReachToValueBlock = { _ in closure() }
        return self
    }
    
    func start() {
        toStart()
    }
    
    func cancel() {
        toCancel()
    }
}
