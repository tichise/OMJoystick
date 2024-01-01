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

    var iconColor: Color // アイコンの色
    var subRingColor: Color // 小さなリングの色
    var bigRingNormalBackgroundColor: Color // 大きなリングの背景色
    var bigRingDarkBackgroundColor: Color // 大きなリングのダークモード時の背景色
    
    // 大きなリングのストローク色
    var bigRingStrokeColor: Color

    // アイコン
    var leftIcon: Image?
    var rightIcon: Image?
    var upIcon: Image?
    var downIcon: Image?
    
    // デバッグモード
    var isDebug: Bool

    // アイコンのパディング
    let iconPadding: CGFloat = 10
    
    // コールバック
    public var completionHandler: ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)
    
    var dragGesture: some Gesture {
        // minimumDistanceが1以上だとタッチイベントを一切拾わない
        DragGesture(minimumDistance: 0)
            .onChanged{ value in
                let distance = viewModel.org.getDistance(otherPoint: value.location)
                
                let smallRingLimitCenter: CGFloat = viewModel.bigRingRadius - viewModel.smallRingRadius
                
                if (distance <= smallRingLimitCenter) {
                    // 円の範囲内
                    viewModel.locationX = value.location.x
                    viewModel.locationY = value.location.y
                } else {
                    // 円の範囲外の場合は
                    let radian = viewModel.org.getRadian(pointOnCircle: value.location)
                    
                    let pointOnCircle = viewModel.org.getPointOnCircle(radius: smallRingLimitCenter, radian: radian)
                    
                    viewModel.locationX = pointOnCircle.x
                    viewModel.locationY = pointOnCircle.y
                }
                
                viewModel.joyStickState = viewModel.getJoyStickState()
                
                self.completionHandler(viewModel.joyStickState,  viewModel.stickPosition)
        }
        .onEnded{ value in
            viewModel.locationX = viewModel.bigRingDiameter/2
            viewModel.locationY = viewModel.bigRingDiameter/2
            
            viewModel.locationX = viewModel.bigRingRadius
            viewModel.locationY = viewModel.bigRingRadius
            
            viewModel.joyStickState = .center
            
            self.completionHandler(viewModel.joyStickState,  viewModel.stickPosition)
        }
    }

    // イニシャライザ
    public init(isDebug: Bool = false, iconSetting: IconSetting? = nil, colorSetting: ColorSetting, smallRingRadius: CGFloat = 50, bigRingRadius: CGFloat = 140, isOctantLinesVisible: Bool = false, completionHandler: @escaping ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)) {
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
        self.viewModel = OMJoystickViewModel(bigRingRadius: bigRingRadius, smallRingRadius: smallRingRadius, isOctantLinesVisible: isOctantLinesVisible)
    }
    
    public var body: some View {
        VStack {
            // デバッグ
            if isDebug {
                VStack {
                    HStack(spacing: 15) {
                        Text(viewModel.stickPosition.x.text()).font(.body)
                        Text(":").font(.body)
                        
                        Text(viewModel.stickPosition.y.text()).font(.body)
                    }
                    
                }.padding(10)
            }

            // 上の向きのアイコン
            upIcon?.renderingMode(.template)
                .foregroundColor(iconColor).padding(iconPadding)
            
            HStack {
                // 左の向きのアイコン
                leftIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
                
                ZStack {
                    // 大きなリング
                    BigRing(
                        bigRingNormalBackgroundColor: bigRingNormalBackgroundColor,
                        bigRingDarkBackgroundColor: bigRingDarkBackgroundColor,
                        bigRingStrokeColor: bigRingStrokeColor,
                        bigRingDiameter: viewModel.bigRingDiameter
                    ).environmentObject(viewModel).gesture(dragGesture)

                    // 小さなリング
                    SmallRing(
                        smallRingDiameter: viewModel.smallRingDiameter,
                        subRingColor: subRingColor
                    ).environmentObject(viewModel).offset(x: viewModel.smallRingLocationX, y: viewModel.smallRingLocationY)
                    .allowsHitTesting(false)
                }
                
                // 右の向きのアイコン
                rightIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
            }
            
            // 下の向きのアイコン
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
                OMJoystick(isDebug: true,  colorSetting: ColorSetting(bigRingStrokeColor: .gray, iconColor: .orange), smallRingRadius: 70, bigRingRadius: 120,isOctantLinesVisible: true) { (joyStickState, stickPosition)  in
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
                           ,isOctantLinesVisible: true) { (joyStickState, stickPosition)  in
                    debugPrint(joyStickState.rawValue)
                    debugPrint(stickPosition)
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
    }
}
