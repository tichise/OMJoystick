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
    
    var isDebug = false
    
    var stickPosition: CGPoint {
        let stickPositionX = floor(locationX - bigRingRadius)
        
        // 上をY軸プラスにするためにマイナスをかける
        var stickPositionY = floor(locationY - bigRingRadius) * -1
        
        // stickPositionYが-0の場合は-を消す
        if (stickPositionY == -0) {
            stickPositionY = 0
        }
        
        return CGPoint(x: stickPositionX, y: stickPositionY)
    }
    
    @State private var joyStickState: JoyStickState = .center
    
    public var completionHandler: ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint, _ angle: CGFloat?, _ distanceFromOrigin: Int) -> Void)
    
    var org: CGPoint {
        return CGPoint(x: self.bigRingRadius, y: self.bigRingRadius)
    }
    
    @State var locationX: CGFloat = 0
    @State var locationY: CGFloat = 0
    
    let iconPadding: CGFloat = 10
    
    var smallRingDiameter: CGFloat {
        return smallRingRadius*2
    }
    
    var bigRingDiameter: CGFloat {
        return bigRingRadius*2
    }
    
    var smallRingRadius: CGFloat
    var bigRingRadius: CGFloat
    
    var smallRingLocationX: CGFloat {
        return locationX - bigRingRadius
    }
    
    var smallRingLocationY: CGFloat {
        return locationY - bigRingRadius
    }
    
    var dragGesture: some Gesture {
        // minimumDistanceが1以上だとタッチイベントを一切拾わない
        DragGesture(minimumDistance: 0)
            .onChanged{ value in
                let distance = self.org.getDistance(otherPoint: value.location)
                
                let smallRingLimitCenter: CGFloat = self.bigRingRadius - self.smallRingRadius
                
                if (distance <= smallRingLimitCenter) {
                    // 円の範囲内
                    self.locationX = value.location.x
                    self.locationY = value.location.y
                    
                    
                } else {
                    // 円の範囲外の場合は
                    let radian = self.org.getRadian(pointOnCircle: value.location)
                    
                    let pointOnCircle = self.org.getPointOnCircle(radius: smallRingLimitCenter, radian: radian)
                    
                    self.locationX = pointOnCircle.x
                    self.locationY = pointOnCircle.y
                }
                
                // 原点からの距離を取得
                let distanceFromOrigin = JoyStickStateCalculator.getDistanceFromOrigin(stickPosition: stickPosition)
                
                // 角度を取得
                let angle = JoyStickStateCalculator.getAngle(stickPosition: stickPosition)
                
                if viewModel.isOctantLinesVisible {
                    // 八等分の場合
                    self.joyStickState = JoyStickStateCalculator.getJoyStickStateOctant(angle: angle,
                        stength: distanceFromOrigin
                    )
                } else {
                    // 四等分の場合
                    self.joyStickState = JoyStickStateCalculator.getJoyStickStateQuadrant(angle: angle,
                        distanceFromOrigin: distanceFromOrigin
                    )
                }
                
                self.completionHandler(self.joyStickState,  self.stickPosition, angle, distanceFromOrigin)
        }
        .onEnded{ value in

            self.locationX = self.bigRingRadius
            self.locationY = self.bigRingRadius
            
            self.joyStickState = .center
            let angle: CGFloat? = nil
            let discanceFromOrigin = 0
            
            self.completionHandler(self.joyStickState,  self.stickPosition, angle, discanceFromOrigin)
        }
    }
    
    
    public init(isDebug: Bool = false, iconSetting: IconSetting? = nil, colorSetting: ColorSetting, smallRingRadius: CGFloat = 50, bigRingRadius: CGFloat = 140, isOctantLinesVisible: Bool = false,
        completionHandler: @escaping ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint, _ angle: CGFloat?, _ distanceFromOrigin: Int) -> Void)) {
        
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
        
        self.smallRingRadius = smallRingRadius
        self.bigRingRadius = bigRingRadius
        
        self.completionHandler = completionHandler
        
        // ViewModelの初期化
        self.viewModel = OMJoystickViewModel(isOctantLinesVisible: isOctantLinesVisible)
    }
    
    public var body: some View {
        
        VStack {
            upIcon?.renderingMode(.template)
                .foregroundColor(iconColor).padding(iconPadding)
            
            HStack() {
                leftIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
                
                ZStack {
                    // 中央は直径280の場合は140:140
                    BigRing(
                        bigRingNormalBackgroundColor: bigRingNormalBackgroundColor,  bigRingDarkBackgroundColor: bigRingDarkBackgroundColor, 
                        bigRingStrokeColor: bigRingStrokeColor,
                        bigRingDiameter: bigRingDiameter).environmentObject(viewModel).gesture(dragGesture)
                    
                    SmallRing(smallRingDiameter: self.smallRingDiameter, subRingColor: subRingColor).offset(x: smallRingLocationX, y: smallRingLocationY).environmentObject(viewModel).allowsHitTesting(false)
                }
                
                rightIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
            }
            
            downIcon?.renderingMode(.template)
                .foregroundColor(iconColor).padding(iconPadding)
            
            if isDebug {                
                VStack(spacing: 5) {
                    HStack() {
                        Text("StickPosition:").font(.body)
                        Text(stickPosition.x.text()).font(.body)
                        Text(":").font(.body)
                        Text(stickPosition.y.text()).font(.body)
                    }
                    HStack {
                        Text("JoyStickState:").font(.body)
                        Text(joyStickState.rawValue).font(.body)
                    }
                    HStack {
                        Text("DistanceFromOrigin:").font(.body)
                        Text(String(JoyStickStateCalculator.getDistanceFromOrigin(stickPosition: stickPosition))).font(.body)
                    }
                    HStack {
                        Text("Angle:").font(.body)
                        Text(JoyStickStateCalculator.getAngle(stickPosition: stickPosition).text()).font(.body)
                    }
                }
            }
        }.onAppear(){
            self.locationX = self.bigRingRadius
            self.locationY = self.bigRingRadius
        }.padding(40)
    }
}

struct OMJoystick_Previews1: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true, colorSetting: ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow, iconColor: .red)) { (joyStickState, stickPosition, angle, distanceFromOrigin) in
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }.padding(.top, 50)
    }
}

struct OMJoystick_Previews2: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true,  colorSetting: ColorSetting(iconColor: .orange), smallRingRadius: 30, bigRingRadius: 120, isOctantLinesVisible: true
                ) { (joyStickState, stickPosition, angle, distanceFromOrigin)  in

                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
        .padding(.top, 50.0)
    }
}
