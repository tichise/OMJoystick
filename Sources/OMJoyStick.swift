//
//  OMJoystick.swift
//  Omicro
//
//  Created by tichise on 2020年8月9日 20/08/09.
//  Copyright © 2020 tichise. All rights reserved.
//

import SwiftUI

public struct OMJoystick: View {
    
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
        
        let stickPositionY = floor((locationY - bigRingRadius) < 0 ? -1 * (locationY - bigRingRadius) : locationY - bigRingRadius)
                
        return CGPoint(x: stickPositionX, y: stickPositionY)
    }
    
    @State private var joyStickState: JoyStickState = .center
    
    public var completionHandler: ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)
        
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
    
    func getJoyStickState() -> JoyStickState {
        var state: JoyStickState = .center
        
        let xValue = locationX - bigRingRadius
        let yValue = locationY - bigRingRadius
        
        if (abs(xValue) > abs(yValue)) {
            state = xValue < 0 ? .left : .right
        } else if (abs(yValue) > abs(xValue)) {
            state = yValue < 0 ? .up : .down
        }
        
        return state
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
                
                self.joyStickState = self.getJoyStickState()
                
                self.completionHandler(self.joyStickState,  self.stickPosition)
        }
        .onEnded{ value in
            self.locationX = self.bigRingDiameter/2
            self.locationY = self.bigRingDiameter/2
            
            self.locationX = self.bigRingRadius
            self.locationY = self.bigRingRadius
            
            self.joyStickState = .center
            
            self.completionHandler(self.joyStickState,  self.stickPosition)
        }
    }
    
    
    public init(isDebug: Bool = false, iconSetting: IconSetting? = nil, colorSetting: ColorSetting, smallRingRadius: CGFloat = 50, bigRingRadius: CGFloat = 140,
        completionHandler: @escaping ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)) {
        
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
    }
    
    public var body: some View {
        
        VStack {
            if isDebug {
                VStack {
                    HStack(spacing: 15) {
                        Text(stickPosition.x.text()).font(.body)
                        Text(":").font(.body)
                        
                        Text(stickPosition.y.text()).font(.body)
                    }
                    
                }.padding(10)
            }
            
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
                        bigRingDiameter: bigRingDiameter).gesture(dragGesture)
                    
                    SmallRing(smallRingDiameter: self.smallRingDiameter, subRingColor: subRingColor).offset(x: smallRingLocationX, y: smallRingLocationY).allowsHitTesting(false)
                }
                
                rightIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
            }
            
            downIcon?.renderingMode(.template)
                .foregroundColor(iconColor).padding(iconPadding)
            
            if isDebug {                
                HStack(spacing: 15) {
                    Text(joyStickState.rawValue).font(.body)
                }
            }
        }.onAppear(){
            self.locationX = self.bigRingRadius
            self.locationY = self.bigRingRadius
        }.padding(40)
    }
}

struct OMJoystick_Previews: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true, colorSetting: ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow, iconColor: .red)) { (joyStickState, stickPosition) in
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
                
                OMJoystick(isDebug: true,  colorSetting: ColorSetting(iconColor: .orange), smallRingRadius: 70, bigRingRadius: 120
                ) { (joyStickState, stickPosition)  in
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
    }
}
