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
//  Color.swift
//  UISpecExampleFramework
//
//  Created by Marc Palmer on 09/01/2018.
//

import Foundation

#if os(macOS)
import AppKit
public typealias ColorType = NSColor
#else
import UIKit
public typealias ColorType = UIColor
#endif

/// A platform independent encapsulation of a color, with
/// convenience functions to facilitate use in themes.
///
/// Most functions and values are internal access only, as they are intended for use only in a UISpec, which could
/// live in a framework along with your cross-platform reusable code.
///
/// - note: This is used instead of categories on UIColor or NSColor to avoid use of those directly and
/// encourage use of the values specified in UI specs only.
public struct Color {
    public let color: ColorType
    public lazy var cgColor: CGColor = { return color.cgColor }()
    
    /// Internal initialiser for UISpecs to create a color from RGBA values.
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) {
        color = ColorType(red: red, green: green, blue: blue, alpha: alpha)
    }

    /// Internal initialiser for UISpecs to create a color from White and Alpha values.
    init(white: CGFloat, alpha: CGFloat = 1.0) {
        color = ColorType(white: white, alpha: alpha)
    }

    /// Internal constant for clear.
    static let clear: Color = .white(0, alpha: 0)

    /// Internal constant for black.
    static let black: Color = .white(0, alpha: 1)
    
    /// Internal factory for creating whites using type inference e.g. `let c: Color = .white(1)`
    static func white(_ white: CGFloat, alpha: CGFloat = 1.0) -> Color {
        return Color(white: white, alpha: alpha)
    }
    
    /// Internal factory for creating RGB colors using type inference
    /// e.g. `let ghastlyYellow: Color = .rgb(1, 1, 0)`
    static func rgb(_ r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> Color {
        return Color(red: r, green: g, blue: b, alpha: alpha)
    }

#if !os(macOS)
    /// Set the `textColor` of the specified label to this color
    public func apply(to label: UILabel) {
        label.textColor = color
    }
    
    /// Set the `textColor` of all the specified labels to this color
    public func apply(to labels: [UILabel]) {
        for label in labels {
            label.textColor = color
        }
    }
    
    /// Set the `backgroundColor` of the specified view to this color
    public func apply(to view: UIView) {
        view.backgroundColor = color
    }
    
    /// Set the `backgroundColor` of all the specified views to this color
    public func apply(to views: [UIView]) {
        for view in views {
            view.backgroundColor = color
        }
    }
#endif
}
