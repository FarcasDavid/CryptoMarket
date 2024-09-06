//
//  UIFont + Extension.swift
//  wipChallengeDavidFarcas
//
//  Created by David Farcas on 16.08.2024.
//

import Foundation
import UIKit

enum FontWeight {
    case bold
    case regular
    case light
    case extraLight
}

extension UIFont {

    class func robotoFont(ofSize fontSize: CGFloat, weight: FontWeight) -> UIFont {

        switch weight {
        case .bold:
            customFont(name: "Roboto-Bold", size: fontSize)
        case .regular:
            customFont(name: "Roboto-Regular", size: fontSize)
        case .light:
            customFont(name: "Roboto-Light", size: fontSize)
        case .extraLight:
            customFont(name: "Roboto-Thin", size: fontSize)
        }

    }

    private class func customFont(name: String, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name, size: size) else {
            return .systemFont(ofSize: size)
        }
        return font
    }

}
