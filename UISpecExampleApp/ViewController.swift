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
//  ViewController.swift
//  UISpecExampleApp
//
//  Created by Marc Palmer on 10/01/2018.
//

import UIKit
import UISpecExampleFramework

class ViewController: UIViewController {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var welcomeTextLabel: UILabel!
    @IBOutlet weak var onboardingCardView: UIView!
    @IBOutlet weak var innerCardView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var innerCardTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerCardLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerCardTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var innerCardBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // This is just a quick example to show how you carry over the styling into
        // your UI. Normally views would take care of this themselves, not the view controller.
        typealias CardSpec = OnboardingUISpec.Card
        
        CardSpec.headingFont.apply(to: headingLabel)
        CardSpec.bodyFont.apply(to: welcomeTextLabel)

        CardSpec.backgroundColor.apply(to: [
            onboardingCardView,
            innerCardView
        ])
        CardSpec.cornerRadius.apply(to: onboardingCardView)

        CardSpec.padding.apply(to: [
            innerCardTopConstraint,
            innerCardLeadingConstraint,
            innerCardTrailingConstraint,
            innerCardBottomConstraint
        ])

        OnboardingUISpec.Buttons.font.apply(to: nextButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
