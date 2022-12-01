//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: ColorProviding2 - temporary stand-in for ColorProviding so we can replace side by side

/// Protocol through which consumers can provide colors to "theme" their experiences
/// The window in which the color will be shown is sent to allow apps to provide different experiences per each window
@objc(MSFColorProviding2)
public protocol ColorProviding2 {
    /// If this protocol is not conformed to, communicationBlue variants will be used
    @objc func brandBackground1(for window: UIWindow) -> UIColor?
    @objc func brandBackground1Pressed(for window: UIWindow) -> UIColor?
    @objc func brandBackground1Selected(for window: UIWindow) -> UIColor?
    @objc func brandBackground2(for window: UIWindow) -> UIColor?
    @objc func brandBackground2Pressed(for window: UIWindow) -> UIColor?
    @objc func brandBackground2Selected(for window: UIWindow) -> UIColor?
    @objc func brandBackground3(for window: UIWindow) -> UIColor?
    @objc func brandBackgroundTint(for window: UIWindow) -> UIColor?
    @objc func brandForeground1(for window: UIWindow) -> UIColor?
    @objc func brandForeground1Pressed(for window: UIWindow) -> UIColor?
    @objc func brandForeground1Selected(for window: UIWindow) -> UIColor?
    @objc func brandForegroundTint(for window: UIWindow) -> UIColor?
    @objc func brandForegroundDisabled1(for window: UIWindow) -> UIColor?
    @objc func brandForegroundDisabled2(for window: UIWindow) -> UIColor?
    @objc func brandStroke1(for window: UIWindow) -> UIColor?
    @objc func brandStroke1Pressed(for window: UIWindow) -> UIColor?
    @objc func brandStroke1Selected(for window: UIWindow) -> UIColor?
}

private func brandColorOverrides(provider: ColorProviding, for window: UIWindow) -> [AliasTokens.BrandColorsTokens: DynamicColor] {
    var brandColors: [AliasTokens.BrandColorsTokens: DynamicColor] = [:]
    if let primary = provider.primaryColor(for: window)?.dynamicColor {
        brandColors[.primary] = primary
    }
    if let tint10 = provider.primaryTint10Color(for: window)?.dynamicColor {
        brandColors[.tint10] = tint10
    }
    if let tint20 = provider.primaryTint20Color(for: window)?.dynamicColor {
        brandColors[.tint20] = tint20
    }
    if let tint30 = provider.primaryTint30Color(for: window)?.dynamicColor {
        brandColors[.tint30] = tint30
    }
    if let tint40 = provider.primaryTint40Color(for: window)?.dynamicColor {
        brandColors[.tint40] = tint40
    }
    if let shade10 = provider.primaryShade10Color(for: window)?.dynamicColor {
        brandColors[.shade10] = shade10
    }
    if let shade20 = provider.primaryShade20Color(for: window)?.dynamicColor {
        brandColors[.shade20] = shade20
    }
    if let shade30 = provider.primaryShade30Color(for: window)?.dynamicColor {
        brandColors[.shade30] = shade30
    }
    return brandColors
}

// MARK: Colors

@objc(MSFColors2)
public final class Colors2: NSObject {
    /// Associates a `ColorProvider2` with a given `UIWindow` instance.
    ///
    /// - Parameters:
    ///   - provider: The `ColorProvider2` whose colors should be used for controls in this window.
    ///   - window: The window where these colors should be applied.
    @objc public static func setProvider(provider: ColorProviding2, for window: UIWindow) {
        colorProvidersMap.setObject(provider, forKey: window)

        // Create an updated fluent theme as well
        let brandColors = brandColorOverrides(provider: provider, for: window)
        let fluentTheme = FluentTheme()
        brandColors.forEach { token, value in
            fluentTheme.aliasTokens.brandColors[token] = value
        }
        window.fluentTheme = fluentTheme
    }

    /// Removes any associated `ColorProvider` from the given `UIWindow` instance.
    ///
    /// - Parameters:
    ///   - window: The window that should have its `ColorProvider` removed.
    @objc public static func removeProvider(for window: UIWindow) {
        colorProvidersMap.removeObject(forKey: window)
        window.fluentTheme = FluentThemeKey.defaultValue
    }

    // MARK: Primary

    /// Use these funcs to grab a color customized by a ColorProviding object for a specific window. If no colorProvider exists for the window, falls back to deprecated singleton theme color
    @objc public static func brandBackground1(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandBackground1(for: window) ?? FallbackThemeColor.brandBackground1
    }

    @objc public static func brandBackground1Pressed(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandBackground1Pressed(for: window) ?? FallbackThemeColor.brandBackground1Pressed
    }

    @objc public static func brandBackground1Selected(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandBackground1Selected(for: window) ?? FallbackThemeColor.brandBackground1Selected
    }

    @objc public static func brandBackground2(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandBackground2(for: window) ?? FallbackThemeColor.brandBackground2
    }

    @objc public static func brandBackground2Pressed(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandBackground2Pressed(for: window) ?? FallbackThemeColor.brandBackground2Pressed
    }

    @objc public static func brandBackground2Selected(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandBackground2Selected(for: window) ?? FallbackThemeColor.brandBackground2Selected
    }

    @objc public static func brandBackground3(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandBackground3(for: window) ?? FallbackThemeColor.brandBackground3
    }

    @objc public static func brandBackgroundTint(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandBackgroundTint(for: window) ?? FallbackThemeColor.brandBackgroundTint
    }

    @objc public static func brandForegroundDisabled(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandForegroundDisabled(for: window) ?? FallbackThemeColor.brandForegroundDisabled
    }

    @objc public static func brandForeground1(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandForeground1(for: window) ?? FallbackThemeColor.brandForeground1
    }

    @objc public static func brandForeground1Pressed(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandForeground1Pressed(for: window) ?? FallbackThemeColor.brandForeground1Pressed
    }

    @objc public static func brandForeground1Selected(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandForeground1Selected(for: window) ?? FallbackThemeColor.brandForeground1Selected
    }

    @objc public static func brandForegroundTint(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandForegroundTint(for: window) ?? FallbackThemeColor.brandForegroundTint
    }

    @objc public static func brandForegroundDisabled1(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandForegroundDisabled1(for: window) ?? FallbackThemeColor.brandForegroundDisabled1
    }

    @objc public static func brandForegroundDisabled2(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandForegroundDisabled2(for: window) ?? FallbackThemeColor.brandForegroundDisabled2
    }

    @objc public static func brandStroke1(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandStroke1(for: window) ?? FallbackThemeColor.brandStroke1
    }

    @objc public static func brandStroke1Pressed(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandStroke1Pressed(for: window) ?? FallbackThemeColor.brandStroke1Pressed
    }

    @objc public static func brandStroke1Selected(for window: UIWindow) -> UIColor {
        return colorProvidersMap.object(forKey: window)?.brandStroke1Selected(for: window) ?? FallbackThemeColor.brandStroke1Selected
    }

    private static var colorProvidersMap = NSMapTable<UIWindow, ColorProviding>(keyOptions: .weakMemory, valueOptions: .weakMemory)

    /// A namespace for holding fallback theme colors (empty enum is an uninhabited type)
    private enum FallbackThemeColor {
        static var brandBackground1: UIColor = AliasTokens.colors[ColorsTokens.brandBackground1]

        static var brandBackground1Pressed: UIColor = AliasTokens.colors[ColorsTokens.brandBackground1Pressed]

        static var brandBackground1Selected: UIColor = AliasTokens.colors[ColorsTokens.brandBackground1Selected]

        static var brandBackground2: UIColor = AliasTokens.colors[ColorsTokens.brandBackground2]

        static var brandBackground2Pressed: UIColor = AliasTokens.colors[ColorsTokens.brandBackground2Pressed]

        static var brandBackground2Selected: UIColor = AliasTokens.colors[ColorsTokens.brandBackground2Selected]

        static var brandBackground3: UIColor = AliasTokens.colors[ColorsTokens.brandBackground3]

        static var brandBackgroundTint: UIColor = AliasTokens.colors[ColorsTokens.brandBackgroundTint]

        static var brandForeground1: UIColor = AliasTokens.colors[ColorsTokens.brandForeground1]

        static var brandForeground1Pressed: UIColor = AliasTokens.colors[ColorsTokens.brandForeground1Selected]

        static var brandForeground1Selected: UIColor = AliasTokens.colors[ColorsTokens.brandStroke1Selected]

        static var brandForegroundTint: UIColor = AliasTokens.colors[ColorsTokens.brandForegroundTint]

        static var brandForegroundDisabled1: UIColor = AliasTokens.colors[ColorsTokens.brandForegroundDisabled1]

        static var brandForegroundDisabled2: UIColor = AliasTokens.colors[ColorsTokens.brandForegroundDisabled2]

        static var brandStroke1: UIColor = AliasTokens.colors[ColorsTokens.brandStroke1]

        static var brandStroke1Pressed: UIColor = AliasTokens.colors[ColorsTokens.brandStroke1Pressed]

        static var brandStroke1Selected: UIColor = AliasTokens.colors[ColorsTokens.brandStroke1Selected]
    }

    @available(*, unavailable)
    override init() {
        super.init()
    }
}
