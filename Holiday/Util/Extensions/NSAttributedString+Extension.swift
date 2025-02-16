//
//  NSAttributedString+Extension.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

extension NSAttributedString {
    func addAttributes(
        _ attributes: [NSAttributedString.Key : Any],
        at matchedString: String...
    ) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        for matched in matchedString {
            let range = string.mutableString.range(of: matched)
            string.addAttributes(attributes, range: range)
        }
        
        return string
    }
}
