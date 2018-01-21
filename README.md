# UISpec, a pattern for App styling in pure Swift

![language:Swift](https://img.shields.io/badge/language-Swift-green.svg?style=flat) ![license:MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)

This is a pattern for expressing UI Style Specifications that you get from designers as Swift code for applications developed for Apple platforms.

Notice the use of "pattern" in that sentence. This is not a framework you just import, it is too trivial for that. There is some useful utility code and a set of guidelines as to how to structure your own code to do this.

Yes this is pure Swift, so pure it won't work with Objective-C. Time to move on!

## Why should I use this pattern?

Do this if you want your UI-related constants to be out of the way of your main code, as well as making it easy to understand and discuss with your designer — even if you are also the designer. Don't convert a large existing project though, there's little profit in that unless you're in a real mess that is holding up your product’s UI work. You can adopt this in small new parts of existing apps as a way to test the ideas and start doing things better in future.

Perhaps the best things about this approach are that is really very simple and does not introduce a new dependency to your Apps.

This approach gives you:

* 100% type safe static compilation, pure Swift. This means you get code completion for all your styling constants! No more “why is my text black?” because you have a style string typo with a dynamic theming system.
* Design consistency throughout your app.
* Supports as many different UISpecs as you like. Easily add new ones for new experimental features or a UI rewrite.
* Hierarchical nesting of design concepts, invaluable when discussing with your designers (tip: don't talk about individual styled items, talk about categories of items that may appear across the whole app).
* Clean building blocks. Don't use arbitrary colours and fonts in your styling constants. Use only those defined in your base UI Spec, which should match 1:1 what your designs laboured over.

There's a [blog post about the high level ideas](https://montanafloss.co/blog/uispec) of this approach.

**This is not a theming system** per se. There are several ways you could adapt it to support theming. Go and experiment! _(hint: you could use protocols to define the static attributes required for different parts of your UI specs, and switch the types you use at runtime)_

## Shut up and show me the code

Here's what it looks like to use a UISpec:

```swift
// This is just a quick example to show how you carry over the styling into
// your UI. Normally views would take care of this themselves, not the view controller.
override func viewDidLoad() {
    super.viewDidLoad()

    // Local typealias is completely optional, but can improve readability.
    typealias CardSpec = OnboardingUISpec.Card
    
    // Assign `font`, as well as `textColor`, to UILabels
    CardSpec.headingFont.apply(to: headingLabel)
    CardSpec.bodyFont.apply(to: welcomeTextLabel)

    // Set `backgroundColor` on all the view passed in to the value of
    // `OnboardingUISpec.Card.backgroundColor`
    CardSpec.backgroundColor.apply(to: [
        onboardingCardView,
        innerCardView
    ])

    // Set the `cornerRadius` of the view's layer and turn on clipping to bounds
    CardSpec.cornerRadius.apply(to: onboardingCardView)

    // Set the `constant` on all of these constraints to the `padding` converted from
    // grid dimensions to screen points
    CardSpec.padding.apply(to: [
        innerCardTopConstraint,
        innerCardLeadingConstraint,
        innerCardTrailingConstraint,
        innerCardBottomConstraint
    ])

    // Set the `titleLabel.font` and `titleTextColor` for `UIControlStateNormal` on the button
    OnboardingUISpec.Buttons.font.apply(to: nextButton)
}
```

This is what a UISpec can look like:

```swift
/// UI Spec for the Onboarding screens of the App.
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
```

To recap, that file above is what you and your designers would look at to set up the look and feel of your App. Your App code accesses these values wherever it needs to, in order to make the design happen. The point is that you can search your code easily for any of these types to find where they are being used, and you can easily re-map high level styles like the body font trivially because your code was never set to reference specific fonts or colours like "boldBigFont" or "pinkWindowBackground".

Underneath all this is your App's own base UI Spec, such as the example [`AppUISpec`](UISpecExampleFramework/Source/UISpecs/AppUISpec.swift):

```swift
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
        static let lightGrey: Color = .white(0.7)
        static let offWhite: Color = .white(0.9)
        static let brandGreen: Color = .rgb(0, 0.5, 0.2)
        static let black: Color = .black
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
```

There are only a few simple types that enable all of this:

* [UISpec](UISpecExampleFramework/Source/UISpec.swift) – Includes a single property defining the grid size and your base UI Spec class conforms to this.
* [GridDimension](UISpecExampleFramework/Source/GridDimension.swift) — A dimension metric using grid units from your `UISpec`. Converts to and from screen points.
* [Color](UISpecExampleFramework/Source/Color.swift) — A platform-independent wrapper around `UIColor`/`NSColor` with helper functions to create and apply them.
* [Font](UISpecExampleFramework/Source/Font.swift) —  A platform-independent wrapper around `UIFon`/`NSFont`  with helper functions to create and apply them, using grid dimensions for sizes.
* [CornerRadiusDimension](UISpecExampleFramework/Source/CornerRadiusDimension.swift) — A subtype of `GridDimension` that adds helpers for applying to views and layers.

Ready to get started? Clone the repository and build the example iOS app. Dig around to see how it works.

## Is that it?

Well, yes. The power is in the ideas rather than the code.

However it is not the end of the possibilities, it is just the beginning. Using Swift patterns of access control, nested types and `typealias` unlocks all kinds of potential. We may add a `TextStyle` or `ViewStyle` type in future for example, and definitely more helper functions to apply styling to other UI elements (and yeah... fill out the macOS implementations probably).

## Emojification

This is fun, but not to everybody's taste. A few judicious `typealias`es and your UI specs can become quite visual:

```swift
class YourUISpec: UISpec {
    ... define the enums for Colors, Dimensions etc. ...

    // Define aliases for the UISpec's types so you can refer to them with Emoji
    private typealias 🎨 = Swatches
    public typealias 🖍 = Colors
    public typealias 📏 = Dimensions
    public typealias 🔤 = Fonts
}
```

...and by the magic of Swift unicode support you can now define your UI Specs something like this:

```swift
/// Emojified UI Spec for the Onboarding screens of the App.
public class OnboardingUISpec: AppUISpec {
    // Convenience copy+paste access to Emojis via a legend:
    // 🖍 = Colors
    // 📏 = Dimensions
    // 🔤 = Fonts
    
    public enum Card {
        public static let backgroundColor = 🖍.cardBackground
        public static let cornerRadius = 📏.smallRadius
        public static let padding = 📏.standardCardPadding

        // MARK: Typography
        
        public static let headingFont = 🔤.massiveMarketingHeading
        public static let bodyFont = 🔤.body
    }
    
    public enum Buttons {
        public static let font = 🔤.body
    }
}
```

## How to use the pattern

Your handy step-by-step guide.

1. Create a class that conforms to the `UISpec` protocol, and defines the grid units for your design.
2. To this class add `typealias`es for the generic metric types (`Font`, `GridDimension` etc.) to simple names e.g.
`typealias Dimension = GridDimension<YourUISpec>`
3. Define all the colours your design uses in your base UISpec as static properties inside a `private enum` called  `Swatches`. Name them descriptively for the colour they are, or a name applied in your visual designs e.g. `brightPink` or `swatch7`. Do not use names like `highlightColor`. The type of these is `Color`.
4. Define the logical (functional) colours in your base UISpec as static properties inside an `enum` called `Colors`. Name these by function and *not* colour, e.g. `standardButtonTextColour`, `cardBackgroundColour`. These are what you use in derived specs.
5. Define your standard units of measurement as top-level static properties on your UI spec, e.g. `one`, `oneQuarter`, using the `Dimension` typealias as the type.
6. Define your standard metrics, such as `cardBorderWidth` that are uniform across your styling, as properties inside an `enum` called `Dimensions`, with the properties using values from your standard units e.g. `static let border = one + oneQuarter` or `static let border = Dimension(1.25)``
7. Define your standard fonts inside an `enum` called `Fonts` using a local typalias for `Font` or the `font()` helper functions defined as extensions on your base UI spec (see example code)
8. Now create new subclasses of your base spec that define the constants with nested enums for namespacing, using values inherited from your base UI Spec.

Note that the use of Swift generics is deliberately kept to a minimum in order to avoid cognitive complexity that comes with this. K.I.S.S.

## Tips

It is important to establish a clear design language with your designer. Break down your UI into conceptual chunks that you have names for, and define your UI spec's nesting and properties using these terms.

Avoid specific visual attributes in names of UI Spec constants except in your base UI Spec. All functional UI Specs should use functional names. If you would have to change the name of a constant later if something about the colour or font changed, you have a bad name.

Have your Interface Builder cake and eat it. We use Interface Builder to create the rough form of UIs and test their layouts in different trait classes and sizes.
We use dummy values for constraint constants, and create outlets for the constraints in the code, and then set the UI Spec's dimensions on those constraints to get the final designed UI. Maybe there's something we can do here with `IBDesignable` in future.
Some will say this is a long-winded way of doing this but it means you can have "abstract" forms of your UI easily edited and prototyped, with "developer mode" colours to identify various views, and at runtime it is magically perfect. It works great.

## Contributing to the project

**Don’t**! This is just a pattern. By all means raise some github issues if you have constructive suggestions for new helpers or types and maybe these will be incorporated in future, but **this is not a Framework** to pull into your code. Did we say that enough?

This is merely an expression of some good ideas that you are free to take and adapt as you see fit. We may well enhance this example in future, so keep an eye out.

Of course please do spread the word and let us know if you enjoy using this.

## Who made this?

The UI Spec approach was arrived at by [Marc Palmer](https://twitter.com/marcpalmerdev) of [Montana Floss Co.](https://montanafloss.co) after several iterations of this approach
in various apps and client contracts. Valuable feedback was provided by Matt Tancock, Mathieu Alvado and Chris Campbell.
