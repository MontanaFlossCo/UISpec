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
//  Font.swift
//  UISpecExampleFramework
//
//  Created by Marc Palmer on 09/01/2018.
//

import Foundation

#if os(macOS)
import AppKit
public typealias FontType = NSFont
#else
import UIKit
public typealias FontType = UIFont
#endif

/// A representation of a font, including an optional color.
public struct Font<T: UISpec> {
    public let font: FontType
    public let face: String
    public let size: GridDimension<T>
    public let color: Color?

    /// Create a new font metric using a custom font.
    /// - note: Not recommended, use system fonts for Dynamic Text!
    init(face: String, size: GridDimension<T>, color: Color? = nil) {
        self.size = size
        self.face = face
        self.color = color
        
        /// Note: we have to have a fallback here because iOS unit tests cannot load custom fonts through the normal
        /// UIFont loader. We could rewrite all this to use a CGDataProvider for the font but... troll ourselves instead
        font = FontType(name: face, size: size.points) ?? FontType.init(name: "Noteworthy", size: 30)!
    }

    /// Derive a font from this font instance, by changing only the color
    func with(color newColor: Color) -> Font {
        return Font<T>(face: face, size: size, color: newColor)
    }

#if !os(macOS)
    /// Create an system font of the given grid dimension size with an optional color
    /// - param systemFontOfSize: The font size as a grid dimension
    /// - param color: The optional color
    init(systemFontOfSize size: GridDimension<T>, color: Color? = nil) {
        font = UIFont.systemFont(ofSize: size.points)
        face = font.fontName
        self.size = size
        self.color = color
    }
    
    /// Preferred initializer for when you support iOS Dynamic Type
    /// - param preferredFontStyle: The Dynamic Type text style
    /// - param color: The optional color
    init(preferredFontStyle: UIFontTextStyle, color: Color? = nil) {
        font = UIFont.preferredFont(forTextStyle: preferredFontStyle)
        face = font.fontName
        size = GridDimension<T>(fromPoints: font.pointSize)
        self.color = color
    }

    /// Apply this font to the supplied `UIButton`.
    /// This will set the font for the `titleLabel` and sets `titleColor` to the `color` for `UIControlStateNormal`.
    /// if a `color` is set.
    public func apply(to button: UIButton) {
        button.titleLabel?.font = font
        if let color = color {
            button.setTitleColor(color.color, for: .normal)
        }
    }

    /// Apply this font to all the supplied `UIButton`(s).
    /// This will set the font for the `titleLabel` and sets `titleColor` to the `color` for `UIControlStateNormal`.
    /// if a `color` is set.
    public func apply(to buttons: [UIButton]) {
        for button in buttons {
            apply(to: button)
        }
    }

    /// Apply this font to the supplied `UILabel`.
    /// This will set the font on and sets `textColor` to the `color` if a `color` is set.
    public func apply(to label: UILabel) {
        label.font = font
        if let color = color {
            label.textColor = color.color
        }
    }

    /// Apply this font to all the supplied `UILabel`s.
    /// This will set the font on and sets `textColor` to the `color` if a `color` is set.
    public func apply(to labels: [UILabel]) {
        for label in labels {
            apply(to: label)
        }
    }
#else
    /// Apply this font to the supplied `NSTextField`.
    /// This will set the font on and sets `textColor` to the `color` if a `color` is set.
    public func apply(to field: NSTextField) {
        field.font = font
        if let color = color {
            field.textColor = color.color
        }
    }

    /// Apply this font to all the supplied `NSTextField`(s).
    /// This will set the font on and sets `textColor` to the `color` if a `color` is set.
    public func apply(to textFields: [NSTextField]) {
        for field in textFields {
            apply(to: field)
        }
    }
#endif
}
