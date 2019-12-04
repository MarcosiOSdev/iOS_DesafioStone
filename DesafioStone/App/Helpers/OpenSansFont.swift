//
//  OpenSansFont.swift
//  DesafioStone
//
//  Created by Marcos Felipe Souza on 03/12/19.
//  Copyright © 2019 Marcos Felipe Souza. All rights reserved.
//

import UIKit


extension UIFont {

    public enum OpenSansType: String {
        case extraboldItalic = "-ExtraboldItalic"
        case semiboldItalic = "-SemiboldItalic"
        case semibold = "-Semibold"
        case regular = ""
        case lightItalic = "Light-Italic"
        case light = "-Light"
        case italic = "-Italic"
        case extraBold = "-ExtraBold"
        case boldItalic = "-BoldItalic"
        case bold = "-Bold"
    }

    static func OpenSans(_ type: OpenSansType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "OpenSans\(type.rawValue)", size: size)!
    }

    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }

    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }

}
