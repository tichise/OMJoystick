//
//  ColorSetting.swift
//
//
//  Created by tichise on 2024/01/01.
//

import SwiftUI

/// Color setting for OMJoystick
public struct ColorSetting {
    var subRingColor: Color
    var bigRingNormalBackgroundColor: Color
    var bigRingDarkBackgroundColor: Color
    var bigRingStrokeColor: Color
    var iconColor: Color
    
    public init(subRingColor: Color = .black,
    bigRingNormalBackgroundColor: Color = .white,
    bigRingDarkBackgroundColor: Color = .black,
    bigRingStrokeColor: Color = Color.black,
    iconColor: Color = Color.primary) {
        
        self.subRingColor = subRingColor
        self.bigRingNormalBackgroundColor = bigRingNormalBackgroundColor
        self.bigRingDarkBackgroundColor = bigRingDarkBackgroundColor
        self.bigRingStrokeColor = bigRingStrokeColor
        self.iconColor = iconColor
    }
}
