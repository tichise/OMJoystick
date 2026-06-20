//
//  SwiftUIView.swift
//  
//
//  Created by tichise on 2024/01/01.
//

import SwiftUI

/// 大きなリング
struct BigRing: View {
    @EnvironmentObject var omJoystickViewModel: OMJoystickViewModel

    @Environment(\.colorScheme) var colorScheme
    
    var bigRingNormalBackgroundColor: Color
    var bigRingDarkBackgroundColor: Color
    var bigRingStrokeColor: Color
    
    var bigRingDiameter: CGFloat
    
    // 円周率を直接記述する
    private let piValue: Double = 3.14159265358979
    
    var body: some View {
        ZStack {
            Circle().stroke(bigRingStrokeColor, lineWidth: 10)
                .frame(width: bigRingDiameter, height: bigRingDiameter)
            
            Circle().fill(colorScheme == .dark ? bigRingDarkBackgroundColor : bigRingNormalBackgroundColor)
                .frame(width: bigRingDiameter, height: bigRingDiameter)
            
            // 操作エリアの区切り線を描く。
            // 8等分（斜め移動あり）なら22.5°刻み、4等分（上下左右のみ）なら45°刻みの
            // 対角線で区切り、どの範囲がどの方向の入力になるかを視覚的に示す。
            // 区切り線の角度はJoyStickStateCalculatorのセクター境界と一致させている。
            let radius = min(bigRingDiameter, bigRingDiameter) / 2
            let center = CGPoint(x: bigRingDiameter / 2, y: bigRingDiameter / 2)

            if omJoystickViewModel.isOctantLinesVisible {
                let divisionCount = 8
                let additionalAngle = piValue / 8 // セクター境界（22.5°刻み）に合わせる

                ForEach(0..<divisionCount, id: \.self) { i in
                    Path { path in
                        path.move(to: center)
                        let angle = CGFloat(i) * piValue / 4 + additionalAngle
                        let endX = center.x + radius * cos(angle)
                        let endY = center.y + radius * sin(angle)
                        path.addLine(to: CGPoint(x: endX, y: endY))
                    }
                    .stroke(bigRingStrokeColor, lineWidth: 1)
                }
            } else {
                let divisionCount = 4
                let additionalAngle = piValue / 4 // セクター境界（45°刻みの対角線）に合わせる

                ForEach(0..<divisionCount, id: \.self) { i in
                    Path { path in
                        path.move(to: center)
                        let angle = CGFloat(i) * piValue / 2 + additionalAngle
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
        BigRing(bigRingNormalBackgroundColor: .white, bigRingDarkBackgroundColor: .black, bigRingStrokeColor: .primary, bigRingDiameter: 120).environmentObject(OMJoystickViewModel(isOctantLinesVisible: true))
        
        BigRing(bigRingNormalBackgroundColor: .white, bigRingDarkBackgroundColor: .gray, bigRingStrokeColor: .red, bigRingDiameter: 220).environmentObject(OMJoystickViewModel(isOctantLinesVisible: true))
        
        BigRing(bigRingNormalBackgroundColor: .white, bigRingDarkBackgroundColor: .black, bigRingStrokeColor: .primary, bigRingDiameter: 120).environmentObject(OMJoystickViewModel(isOctantLinesVisible: false))
    }
}
