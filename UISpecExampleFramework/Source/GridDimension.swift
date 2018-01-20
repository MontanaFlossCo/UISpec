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
//  GridDimension.swift
//  UISpecExampleFramework
//
//  Created by Marc Palmer on 09/01/2018.
//

import Foundation

/// A dimension for a UI Spec, based on a grid unit comprising N points per unit.
///
/// Specifying all UI spec dimensions in this way keeps you true to your grid and avoids dealing with
/// of point sizes. You can alter your app's grid size by changing one value in your UI Spec.
public class GridDimension<T: UISpec>: ExpressibleByFloatLiteral {

    /// The points value of the dimension, e.g. CoreGraphics points (at 1:1)
    public let points: CGFloat

    /// The grid units value of the dimension
    let gridUnits: CGFloat
    
    /// The number of CoreGraphics points per grid unit.
    /// points = pointsPerUnit * gridUnits
    let pointsPerUnit: CGFloat

    /// Standard initializer
    init(_ value: CGFloat) {
        self.pointsPerUnit = T.pointsPerGridUnit
        gridUnits = value
        points = value * pointsPerUnit
    }
    
    /// Reverse-create a grid dimension based on points.
    /// Not particularly useful but used for completeness and Dynamic Type font support.
    init(fromPoints value: CGFloat) {
        self.pointsPerUnit = T.pointsPerGridUnit
        gridUnits = value / pointsPerUnit
        points = value
    }
    
    // MARK: Automatic coercion from float literals
    
    public typealias FloatLiteralType = Double
    
    public required init(floatLiteral value: FloatLiteralType) {
        self.pointsPerUnit = T.pointsPerGridUnit
        gridUnits = CGFloat(value)
        points = CGFloat(value * Double(pointsPerUnit))
    }

    // MARK: Helpers
    
    /// Apply the points value of this dimension to the specified constraint's `constant`
    public func apply(to constraint: NSLayoutConstraint) {
        constraint.constant = points
    }
    
    /// Apply the points value of this dimension to all of the specified constraints' `constant`
    public func apply(to constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            constraint.constant = points
        }
    }
}


/// Support for adding two metrics together, without converting them to display points first
public func +<T>(lhs: GridDimension<T>, rhs: GridDimension<T>) -> GridDimension<T>{
    return GridDimension<T>(lhs.points + rhs.points)
}

/// Support for subtracting two metrics together, without converting them to display points first
public func -<T>(lhs: GridDimension<T>, rhs: GridDimension<T>) -> GridDimension<T> {
    return GridDimension<T>(lhs.points - rhs.points)
}

/// Support for multiplying a metric by an int, without converting them to display points first
public func *<T>(lhs: IntegerLiteralType, rhs: GridDimension<T>) -> GridDimension<T> {
    return GridDimension<T>(CGFloat(lhs) * rhs.points)
}

/// Support for multiplying a metric by an int, without converting them to display points first
public func *<T>(lhs: FloatLiteralType, rhs: GridDimension<T>) -> GridDimension<T> {
    return GridDimension<T>(CGFloat(lhs) * rhs.points)
}
