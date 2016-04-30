//
//  Animation.swift
//  PopSwift
//
//  Created by James Taylor on 2016-04-28.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

import pop

/// Mostly a wrapper around PopAnimation exposing some functions
/// promoting chaining with trailing closure syntax at the call site.
public struct Animation {
    
    private let popAnimation: POPAnimation
    
    private let toStart: () -> ()
    private let toCancel: () -> ()
    
    init(popAnimation: POPAnimation, toStart: () -> (), toCancel: () -> ()) {
        self.popAnimation = popAnimation
        self.toStart = toStart
        self.toCancel = toCancel
    }
}

public extension Animation {
    
    func onApply(onApply: () -> ()) -> Animation {
        popAnimation.animationDidApplyBlock = { _ in onApply() }
        return self
    }
    
    func onComplete(onComplete: () -> ()) -> Animation {
        popAnimation.completionBlock = { _ in onComplete() }
        return self
    }
    
    func onReachedToValue(closure: () -> ()) -> Animation {
        popAnimation.animationDidReachToValueBlock = { _ in closure() }
        return self
    }
    
    func start() {
        toStart()
    }
    
    func cancel() {
        toCancel()
    }
}
