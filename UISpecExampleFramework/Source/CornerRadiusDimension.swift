//  Copyright 2018 Montana Floss Co. Ltd.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
//  persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//  CornerRadiusDimension.swift
//  UISpecExampleFramework
//
//  Created by Marc Palmer on 10/01/2018.
//

import Foundation
#if os(macOS)
import AppKit
#else
import UIKit
#endif

/// A dimension for a radius. Allows for helper functions to apply radius to views and layers
public class CornerRadiusDimension<T: UISpec>: GridDimension<T> {

    /// Initializer for taking a grid dimension to use as a radius
    init(_ gridDimension: GridDimension<T>) {
        super.init(gridDimension.gridUnits)
    }
    
    /// Initializer for create radii from float literals
    required public init(floatLiteral value: FloatLiteralType) {
        super.init(floatLiteral: value)
    }

    /// Apply the value to the corner radius of the layer and set maskToBounds to `true`
    public func apply(to layer: CALayer) {
        layer.cornerRadius = points
        layer.masksToBounds = true
    }

    /// Apply the value to the corner radius of all the layers and set maskToBounds to `true`
    public func apply(to layers: [CALayer]) {
        for layer in layers {
            apply(to: layer)
        }
    }

#if !os(macOS)
    /// Apply the value to the corner radius of the view and set clipsToBounds to `true`
    public func apply(to view: UIView) {
        view.layer.cornerRadius = points
        view.clipsToBounds = true
    }

    /// Apply the value to the corner radius of all the views and set clipsToBounds to `true`
    public func apply(to views: [UIView]) {
        for view in views {
            apply(to: view)
        }
    }
#endif
}
