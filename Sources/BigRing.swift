//
//  SwiftUIView.swift
//  
//
//  Created by tichise on 2024/01/01.
//

import SwiftUI

/// OMJoystick
struct BigRing: View {
    @Environment(\.colorScheme) var colorScheme
    
    var bigRingNormalBackgroundColor: Color
    var bigRingDarkBackgroundColor: Color
    var bigRingStrokeColor: Color
    
    var bigRingDiameter: CGFloat
    
    var body: some View {
        ZStack {
            // 外枠
            Circle().stroke(bigRingStrokeColor, lineWidth: 10)
                .frame(width: bigRingDiameter, height: bigRingDiameter)
            
            // 内側
            Circle().fill(colorScheme == .dark ? bigRingDarkBackgroundColor : bigRingNormalBackgroundColor)
                .frame(width: bigRingDiameter, height: bigRingDiameter)
        }
    }
}

// BingRingのPreview用
struct BigRing_Previews: PreviewProvider {
    static var previews: some View {
        BigRing(bigRingNormalBackgroundColor: .white, bigRingDarkBackgroundColor: .black, bigRingStrokeColor: .primary, bigRingDiameter: 100)
    }
}
