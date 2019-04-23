//
//  UIRoundedView.swift
//
//  Created by Craz1k0ek on 19/04/2019.
//

import UIKit

@IBDesignable class UIRoundedView: UIShadowView {
    
    /// The radius to use when drawing rounded corners for the layer’s background.
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

}
