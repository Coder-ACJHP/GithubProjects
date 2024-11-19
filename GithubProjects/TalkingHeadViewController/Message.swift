//
//  Message.swift
//  UIKitAnimations
//
//  Created by Coder ACJHP on 7.11.2024.
//

import Foundation

enum IsFrom: CaseIterable {
    case user, ai
}

struct Message {
    var text: String
    var isFrom: IsFrom
}
