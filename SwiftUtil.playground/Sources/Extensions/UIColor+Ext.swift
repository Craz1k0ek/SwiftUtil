//
//  UIColor+Ext.swift
//
//  Created by Craz1k0ek on 05/02/2019.
//

import UIKit

public extension UIColor {
    
    /// Initialize a `UIColor` with a hexadecimal `String` and an optional alpha value.
    ///
    /// - Note: This function will not validate any input.
    /// Providing not exactly 6 hexadecimal characters might give unwanted behaviour.
    /// - Parameters:
    ///   - hexString: The hexadecimal color string.
    ///   - alpha: The alpha component of the color, optional, defaults to `1.0`.
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        if #available(iOS 13, *) {
            var rgbValue: UInt64 = 0
            Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: hexFormatted).scanHexInt32(&rgbValue)
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: alpha)
        }
    }
    
    /// Initialize a UIColor for both light and dark appearances.
    /// - Note: This uses the `iOS 13` dark mode, meaning, the functionality for the dark mode is only available for `>= iOS 13`.
    /// - Parameter light: The light appearance `UIColor`.
    /// - Parameter dark: The dark appearance `UIColor`.
    convenience init(light: UIColor, dark: UIColor) {
        if #available(iOS 13.0, *) {
            self.init { (traits) -> UIColor in
                switch traits.userInterfaceStyle {
                case .dark:
                    return dark
                default:
                    return light
                }
            }
        } else {
            self.init(cgColor: light.cgColor)
        }
    }
    
    /// Retrieve the red, green, blue and alpha component for a color.
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat    = 0
        var green: CGFloat  = 0
        var blue: CGFloat   = 0
        var alpha: CGFloat  = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red: red, green: green, blue: blue, alpha: alpha)
    }
        
    /// Decide the best contrasting color for any given color.
    ///
    /// - Note: This is an implementation of https://www.w3.org/TR/WCAG20/#relativeluminancedef.
    /// - Parameter colorIn: The color to find the best contrasting color for.
    /// - Returns: A `UIColor`, either black or white, that has the best contrast.
    static func wcag20contrast(forColor colorIn: UIColor) -> UIColor {
        let rgba            = colorIn.rgba
        let rgbaComponents  = [rgba.red, rgba.green, rgba.blue]
                
        let luminanceComponents = rgbaComponents.map({ value -> (CGFloat) in
            if value < 0.03928 {
                return value / 12.92
            } else {
                return pow((value + 0.55) / 1.055, 2.4)
            }
        })
        
        let luminance = 0.2126 * luminanceComponents[0] +
                        0.7125 * luminanceComponents[1] +
                        0.0722 * luminanceComponents[2]
        
        return luminance > 0.179 ? .black : .white
    }
    
    /// Decice the best contrasting color for any given color.
    ///
    /// - Parameter colorIn: The color to find the best contrasting color for.
    /// - Returns: A `UIColor`, either black or white, that has the best contrast.
    static func contrast(forColor colorIn: UIColor) -> UIColor {
        let rgba = colorIn.rgba
        let lum = (0.299 * rgba.red) + (0.587 * rgba.green) + (0.114 * rgba.blue)
        return lum > 0.4 ? .black : .white
    }
    
}
