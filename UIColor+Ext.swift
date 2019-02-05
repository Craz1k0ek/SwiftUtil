//
//  UIColor+Ext.swift
//
//  Created by Craz1k0ek on 05/02/2019.
//

import UIKit

extension UIColor {
    
    /// Initialize a `UIColor` with a hexadecimal `String` and an optional alpha value.
    ///
    /// - Note: This function will not validate any input.
    /// Providing not exactly 6 hexadecimal characters might give unwanted behaviour.
    /// - Parameters:
    ///   - hexString: The hexadecimal color string.
    ///   - alpha: The alpha component of the color, optional, defaults to `1.0`.
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexInt: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        scanner.scanHexInt32(&hexInt)
        
        let red = CGFloat((hexInt & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexInt & 0xff00) >> 8) / 255.0
        let blue = CGFloat(hexInt & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Retrieve the red, green, blue and alpha component for a color.
    ///
    /// - Returns: A tuple with the color components (red, green, blue, alpha).
    func getRGBA() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
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
        let rgba            = colorIn.getRGBA()
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
        let rgba = colorIn.getRGBA()
        let lum = (0.299 * rgba.red) + (0.587 * rgba.green) + (0.114 * rgba.blue)
        return lum > 0.4 ? .black : .white
    }
    
}
