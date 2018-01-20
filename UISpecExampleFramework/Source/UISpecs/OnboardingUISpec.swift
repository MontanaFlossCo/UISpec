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
//  OnboardingUISpec.swift
//  UISpecExampleFramework
//
//  Created by Marc Palmer on 09/01/2018.
//

import Foundation

/// An example of a UI Spec for s single functional area of an App.
public class OnboardingUISpec: AppUISpec {

    /// Constants relating to the styling of Card(s) in the Onboarding UI
    public enum Card {
        /// Cards in onboarding use the standard App card color
        public static let backgroundColor = Colors.cardBackground

        /// Round off the corners. A `RadiusDimension` that can set all the required properties on a view
        public static let cornerRadius = Dimensions.smallRadius
        
        /// Dimensions can be applied to constraints
        public static let padding = Dimensions.standardCardPadding

        // MARK: Typography
        
        /// Fonts can be applied to UI elements using helper functions, and include the color.
        /// Using values inherited from `Fonts` means typography is consistent across the app
        /// and easily tweaked at a high level.
        public static let headingFont = Fonts.massiveMarketingHeading
        public static let bodyFont = Fonts.body
    }
    
    /// Constants relating to the styling of Button(s) in the Onboarding UI
    public enum Buttons {
        public static let font = Fonts.body
    }
}
