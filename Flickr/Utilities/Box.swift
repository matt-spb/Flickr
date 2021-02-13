//
//  Box.swift
//  Flickr
//
//  Created by matt_spb on 26.01.2021.
//  Copyright © 2021 matt_spb_dev. All rights reserved.
//

import Foundation

final class Box<T> {
    
    // 1. Each Box can have a Listener that Box notifies when the value changes
    
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    // 2. Box has a generic type value. The didSet property observer detects any changes and notifies Listener of any value update
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    // 3. The initializer sets Box‘s initial value
    
    init(_ value: T) {
        self.value = value
    }
    
    //  4. When a Listener calls bind(listener:) on Box, it becomes Listener and immediately gets notified of the Box‘s current value
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}

