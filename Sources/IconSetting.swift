//
//  IconSetting.swift
//
//
//  Created by tichise on 2024/01/01.
//

import SwiftUI

public struct IconSetting {
    var leftIcon: Image
    var rightIcon: Image
    var upIcon: Image
    var downIcon: Image
    
    public init(leftIcon: Image, rightIcon: Image, upIcon: Image, downIcon: Image) {
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.upIcon = upIcon
        self.downIcon = downIcon
    }
}
