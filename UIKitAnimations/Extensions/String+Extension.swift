//
//  String+Extension.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 14.11.2024.
//

import Foundation

extension String {
    func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return String(self[range])
    }
}
