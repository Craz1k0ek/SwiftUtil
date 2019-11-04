//
//  UIPatternView.swift
//
//  Created by Craz1k0ek on 23/04/2019.
//

import UIKit

@IBDesignable
public class UIPatternView: UIView {
    
    /// The `UIImage` that should be used as a background pattern.
    @IBInspectable
    public var patternImage: UIImage? = nil {
        didSet {
            backgroundColor = patternImage != nil ? UIColor(patternImage: patternImage!) : .clear
        }
    }
    
    /// The scale of the background image.
    @IBInspectable
    public var patternScale: CGFloat = 1.0 {
        didSet {
            if patternImage == nil { return }
            
            let size = patternImage!.size
            let scaled = CGSize(width: size.width * patternScale, height: size.height * patternScale)
            
            UIGraphicsBeginImageContextWithOptions(scaled, false, 0)
            patternImage!.draw(in: CGRect(x: 0, y: 0, width: scaled.width, height: scaled.height))
            
            if let scaledImage = UIGraphicsGetImageFromCurrentImageContext() {
                backgroundColor = UIColor(patternImage: scaledImage)
            }
            UIGraphicsEndImageContext()
        }
    }

}

