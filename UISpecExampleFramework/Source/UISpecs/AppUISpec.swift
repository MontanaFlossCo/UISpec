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
//  AppUISpec.swift
//  UISpecExampleFramework
//
//  Created by Marc Palmer on 09/01/2018.
//

import Foundation
import UIKit

/// Your base UI Spec, setting grid size and fundamental constants and typealiases used in
/// screen/function specific UI Specs
public class AppUISpec: UISpec {
    /// The App uses a 50pt grid as its base unit
    public static let pointsPerGridUnit: CGFloat = 50.0

    /// Define local types for the metrics that require access to the grid size of this UISpec
    public typealias Dimension = GridDimension<AppUISpec>
    public typealias Radius = CornerRadiusDimension<AppUISpec>

    /// The standard grid dimensions our layouts use.
    /// Descendent UI specs inherit access to these.
    /// Normally you don't create any explicit dimensions
    /// and use only these. Having them at the "top level"
    /// namespace makes it more convenien to refer to them
    static let one: Dimension = 1.0
    static let two: Dimension = 2.0
    static let three: Dimension = 3.0
    static let four: Dimension = 4.0
    static let oneHalf: Dimension = 0.5
    static let oneThird = Dimension(1/3)
    static let twoThirds = Dimension(2/3)
    static let oneQuarter = Dimension(1/4)
    static let oneFifth = Dimension(1/5)
    static let oneEigth = Dimension(1/8)
    static let oneTenth = Dimension(1/10)
    
    /// The list of all colours uses in the App.
    /// These are named appropriately for the literal color they are.
    /// They are only accessible to this class, and UI Specs
    /// that descend from this class will only access
    /// colors through the logical colors defined in `Colors`
    private enum Swatches {
        static let lightGrey = Color(white: 0.7)
        static let offWhite = Color(white: 0.9)
        static let brandGreen = Color(red: 0, green: 0.5, blue: 0.2)
        static let black = Color.black
    }
    
    /// The list of logical colours available to the App's UI specs.
    /// They are named by function and possible "variant",
    /// so that App UI Specs never refer to specific colors.
    /// You name these according to your design language, which takes a little
    /// thought up front but is very useful.
    enum Colors {
        static let lightShadow = Swatches.lightGrey
        static let largeHeadingText = Swatches.black
        static let bodyText = Swatches.brandGreen
        static let cardBackground = Swatches.offWhite
    }
    
    /// Standard logical dimensions, named by their function.
    /// An example: many UI Specs may use cards, and you usually want
    /// all of them to have a consistent corner radius and padding.
    enum Dimensions {
        static let smallRadius = Radius(oneFifth)
        static let standardCardPadding = oneHalf
    }
    
    /// Your logical fonts, the "palette" of all fonts used in the app.
    /// Resist defining other fonts in UI Specs, just choose from these.
    enum Fonts {
        static let heading = font(.headline, color: Colors.largeHeadingText)
        static let body = font(.body, color: Colors.bodyText)
        static let massiveMarketingHeading = systemFont(size: one, color: Colors.largeHeadingText)
    }
}

/// Here we add helper functions that essentially create a mini Domain-Specific Language
/// for UISpecs that descend from this.
///
/// - note: These are not provided on the UISpec protocol because this prevents use
/// of type aliases in this base class, as type aliases in this class would be incompatible
/// with these functions in descendent UI Specs.
extension AppUISpec {

    /// Create a CGSize based on grid dimensions.
    static func size(_ w: GridDimension<AppUISpec>, _ h: GridDimension<AppUISpec>) -> CGSize {
        return CGSize(width: w.points, height: h.points)
    }

    /// Create a CGRect based on grid dimensions.
    static func rect(x: GridDimension<AppUISpec>, y: GridDimension<AppUISpec>, width: GridDimension<AppUISpec>, height: GridDimension<AppUISpec>)  -> CGRect {
        return CGRect(x: x.points, y: y.points, width: width.points, height: height.points)
    }

    /// Create a Font based on grid dimensions.
    /// - param faceName: The font face name
    /// - param size: The size of the font, as a grid dimension
    /// - param color: Optional color to associate with the font
    static func font(_ faceName: String, size: GridDimension<AppUISpec>, color: Color? = nil) -> Font<AppUISpec> {
        return Font<AppUISpec>(face: faceName, size: size, color: color)
    }

#if !os(macOS)
    /// Create UIEdgeInsets using grid dimensions.
    /// - param faceName: The font face name
    /// - param size: The size of the font, as a grid dimension
    /// - param color: Optional color to associate with the font
    static func edgeInsets(top: GridDimension<AppUISpec>, left: GridDimension<AppUISpec>, bottom: GridDimension<AppUISpec>, right: GridDimension<AppUISpec>) -> UIEdgeInsets {
        return UIEdgeInsets(top: top.points, left: left.points, bottom: bottom.points, right: right.points)
    }

    /// Create a system Font using iOS Dynamic Text styles.
    /// - param preferredFontStyle: The iOS dynamic text style constant
    /// - param color: Optional color to associate with the font
    static func font(_ preferredFontStyle: UIFontTextStyle, color: Color? = nil) -> Font<AppUISpec> {
        return Font<AppUISpec>(preferredFontStyle: preferredFontStyle, color: color)
    }

    /// Create a system Font using grid dimensions.
    /// - param size: The size of the font, as a grid dimension
    /// - param color: Optional color to associate with the font
    static func systemFont(size: GridDimension<AppUISpec>, color: Color? = nil) -> Font<AppUISpec> {
        return Font<AppUISpec>(systemFontOfSize: size, color: color)
    }
#endif
}

