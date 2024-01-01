//
//  SwiftUIView.swift
//  
//
//  Created by tichise on 2024/01/01.
//

import SwiftUI

struct BigRing: View {
    @Environment(\.colorScheme) var colorScheme
    
    var bigRingNormalBackgroundColor: Color
    var bigRingDarkBackgroundColor: Color
    var bigRingStrokeColor: Color
    
    var bigRingDiameter: CGFloat
    
    // 8等分のラインを表示するか制御する
    @Binding var isSplitLine: Bool
    
    var body: some View {
        ZStack {
            Circle().stroke(bigRingStrokeColor, lineWidth: 10)
                .frame(width: bigRingDiameter, height: bigRingDiameter)
            
            Circle().fill(colorScheme == .dark ? bigRingDarkBackgroundColor : bigRingNormalBackgroundColor)
                .frame(width: bigRingDiameter, height: bigRingDiameter)
            
            if isSplitLine {
                let radius = min(bigRingDiameter, bigRingDiameter) / 2
                let center = CGPoint(x: bigRingDiameter / 2, y: bigRingDiameter / 2)
                
                 
                    ForEach(0..<8) { i in
                        Path { path in
                            path.move(to: center)
                            let angle = CGFloat(i) * .pi / 4 // 45度をラジアンに変換
                            let endX = center.x + radius * cos(angle)
                            let endY = center.y + radius * sin(angle)
                            path.addLine(to: CGPoint(x: endX, y: endY))
                        }
                        .stroke(bigRingStrokeColor, lineWidth: 1)
                    }
            }
            
            

        }.frame(width: bigRingDiameter, height: bigRingDiameter)
    }
}

// BingRingのPreview用
struct BigRing_Previews: PreviewProvider {
    static var previews: some View {
        BigRing(bigRingNormalBackgroundColor: .white, bigRingDarkBackgroundColor: .black, bigRingStrokeColor: .primary, bigRingDiameter: 100, isSplitLine: .constant(false))
    }
}
