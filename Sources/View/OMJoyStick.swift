//
//  OMJoystick.swift
//  Omicro
//
//  Created by tichise on 2020年8月9日 20/08/09.
//  Copyright © 2020 tichise. All rights reserved.
//

import SwiftUI

public struct OMJoystick: View {
    @ObservedObject var viewModel: OMJoystickViewModel

    var iconColor: Color
    var subRingColor: Color
    var bigRingNormalBackgroundColor: Color
    var bigRingDarkBackgroundColor: Color
    var bigRingStrokeColor: Color

    var leftIcon: Image?
    var rightIcon: Image?
    var upIcon: Image?
    var downIcon: Image?
    
    var isDebug: Bool

    let iconPadding: CGFloat = 10

    public var completionHandler: ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)

    public init(isDebug: Bool = false, iconSetting: IconSetting? = nil, colorSetting: ColorSetting, smallRingRadius: CGFloat = 50, bigRingRadius: CGFloat = 140, completionHandler: @escaping ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)) {
        self.isDebug = isDebug
        self.iconColor = colorSetting.iconColor
        self.subRingColor = colorSetting.subRingColor
        self.bigRingNormalBackgroundColor = colorSetting.bigRingNormalBackgroundColor
        self.bigRingDarkBackgroundColor = colorSetting.bigRingDarkBackgroundColor
        self.bigRingStrokeColor = colorSetting.bigRingStrokeColor

        if let iconSetting = iconSetting {
            self.leftIcon = iconSetting.leftIcon
            self.rightIcon = iconSetting.rightIcon
            self.upIcon = iconSetting.upIcon
            self.downIcon = iconSetting.downIcon
        }
        
        self.completionHandler = completionHandler
        self.viewModel = OMJoystickViewModel(bigRingRadius: bigRingRadius, smallRingRadius: smallRingRadius)
    }
    
    public var body: some View {
        VStack {
            if isDebug {
                VStack {
                    HStack(spacing: 15) {
                        Text(viewModel.stickPosition.x.text()).font(.body)
                        Text(":").font(.body)
                        
                        Text(viewModel.stickPosition.y.text()).font(.body)
                    }
                    
                }.padding(10)
            }
            
            upIcon?.renderingMode(.template)
                .foregroundColor(iconColor).padding(iconPadding)
            
            HStack {
                leftIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
                
                ZStack {
                    BigRing(
                        bigRingNormalBackgroundColor: bigRingNormalBackgroundColor,
                        bigRingDarkBackgroundColor: bigRingDarkBackgroundColor,
                        bigRingStrokeColor: bigRingStrokeColor,
                        bigRingDiameter: viewModel.bigRingDiameter
                    ).environmentObject(viewModel).gesture(viewModel.dragGesture)

                    SmallRing(
                        smallRingDiameter: viewModel.smallRingDiameter,
                        subRingColor: subRingColor
                    ).environmentObject(viewModel).offset(x: viewModel.smallRingLocationX, y: viewModel.smallRingLocationY)
                    .allowsHitTesting(false)
                }
                
                rightIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
            }
            
            downIcon?.renderingMode(.template)
                .foregroundColor(iconColor).padding(iconPadding)
            
            if isDebug {
                HStack(spacing: 15) {
                    Text(viewModel.joyStickState.rawValue).font(.body)
                }
            }
        }
        .onAppear(){
            viewModel.resetPosition()
        }
        .padding(40)
    }
}

// その他のプレビュープロバイダーも同様に更新します。

struct OMJoystick_Previews1: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true, colorSetting: ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow, iconColor: .red)) { (joyStickState, stickPosition) in
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
    }
}

struct OMJoystick_Previews2: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true,  colorSetting: ColorSetting(iconColor: .orange), smallRingRadius: 70, bigRingRadius: 120
                ) { (joyStickState, stickPosition)  in
                    debugPrint(joyStickState.rawValue)
                    debugPrint(stickPosition)
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
    }
}

struct OMJoystick_Previews3: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true,  colorSetting: ColorSetting(iconColor: .orange), smallRingRadius: 10, bigRingRadius: 20
                ) { (joyStickState, stickPosition)  in
                    debugPrint(joyStickState.rawValue)
                    debugPrint(stickPosition)
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
    }
}

