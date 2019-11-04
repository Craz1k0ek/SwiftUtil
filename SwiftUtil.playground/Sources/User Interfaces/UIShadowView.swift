//
//  UIShadowView.swift
//
//  Created by Craz1k0ek on 19/04/2019.
//

import UIKit

@IBDesignable
public class UIShadowView: UIView {
    
    /// The color of the layer’s shadow.
    @IBInspectable
    public var shadowColor: UIColor = .darkGray {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    /// The offset (in points) of the layer’s shadow.
    @IBInspectable
    public var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    /// The blur radius (in points) used to render the layer’s shadow.
    @IBInspectable
    public var shadowRadius: CGFloat = 0.0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    /// Boolean value to enable or disable the shadow.
    @IBInspectable
    public var hasShadow: Bool = false {
        didSet {
            if hasShadow {
                layer.shadowOffset = shadowOffset
                layer.shadowOpacity = 1.0
                layer.shadowRadius = shadowRadius
            } else {
                layer.shadowOpacity = 0.0
                layer.shadowRadius = 0.0
            }
        }
    }

}
