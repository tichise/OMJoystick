//
//  OMJoystick.swift
//  Omicro
//
//  Created by tichise on 2020年8月9日 20/08/09.
//  Copyright © 2020 tichise. All rights reserved.
//

import SwiftUI

struct SmallRing: View {
    var smallRingDiameter: CGFloat
    var subRingColor: Color
    
    var body: some View {
        Circle().fill(subRingColor)
            .frame(width: smallRingDiameter, height: smallRingDiameter)
    }
}

struct BigRing: View {
    @Environment(\.colorScheme) var colorScheme
    
    var bigRingNormalBackgroundColor: Color
    var bigRingDarkBackgroundColor: Color
    var bigRingStrokeColor: Color
    
    var bigRingDiameter: CGFloat
    
    var body: some View {
        ZStack {
            Circle().stroke(bigRingStrokeColor, lineWidth: 10)
                .frame(width: bigRingDiameter, height: bigRingDiameter)
            
            Circle().fill(colorScheme == .dark ? bigRingDarkBackgroundColor : bigRingNormalBackgroundColor)
                .frame(width: bigRingDiameter, height: bigRingDiameter)
        }
    }
}

extension CGFloat {
    func text() -> String {
        return String(format: "%.00f", Float(self))
    }
}

public enum JoyStickState: String {
    case up
    case down
    case left
    case right
    case center
}

public struct OMJoystick: View {
    
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
        let stickPositionX = locationX - bigRingRadius
        let stickPositionY = locationY - bigRingRadius
        
        return CGPoint(x: stickPositionX, y: stickPositionY)
    }
    
    @State private var joyStickState: JoyStickState = .center
    
    public var completionHandler: ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)
        
    var org: CGPoint {
        return CGPoint(x: self.bigRingRadius, y: self.bigRingRadius)
    }
    
    @State var locationX: CGFloat = 0
    @State var locationY: CGFloat = 0
    
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
                let distance = self.org.distanceToPoint(otherPoint: value.location)
                
                let smallRingLimitCenter: CGFloat = self.bigRingRadius - self.smallRingRadius
                
                if (distance <= smallRingLimitCenter) {
                    // 円の範囲内
                    self.locationX = value.location.x
                    self.locationY = value.location.y
                    
                    
                } else {
                    // 円の範囲外の場合は
                    let angle = self.org.angleToPoint(pointOnCircle: value.location)
                    
                    let pointOnCircle = self.org.pointOnCircle(radius: smallRingLimitCenter, angle: angle)
                    
                    self.locationX = pointOnCircle.x
                    self.locationY = pointOnCircle.y
                }
                
                self.joyStickState = self.getJoyStickState()
                
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
    
    public init(isDebug: Bool = false, leftIcon: Image? = nil, rightIcon: Image? = nil, upIcon: Image? = nil, downIcon: Image? = nil, smallRingRadius: CGFloat = 50, bigRingRadius: CGFloat = 140,
                
        subRingColor: Color = .primary,
        bigRingNormalBackgroundColor: Color = .white,
        bigRingDarkBackgroundColor: Color = .black,
        bigRingStrokeColor: Color = Color.primary,
        completionHandler: @escaping ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)) {
        
        self.isDebug = isDebug
        
        self.subRingColor = subRingColor
        self.bigRingNormalBackgroundColor = bigRingNormalBackgroundColor
        self.bigRingDarkBackgroundColor = bigRingDarkBackgroundColor
        self.bigRingStrokeColor = bigRingStrokeColor
        
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.upIcon = upIcon
        self.downIcon = downIcon
        
        self.smallRingRadius = smallRingRadius
        self.bigRingRadius = bigRingRadius
        
        self.completionHandler = completionHandler
    }
    
    public var body: some View {
        
        VStack {
            if isDebug {
                VStack {
                    HStack(spacing: 15) {
                        Text(locationX.text()).font(.body)
                        Text(":").font(.body)
                        
                        Text(locationY.text()).font(.body)
                    }
                    
                }.padding(10)
                
                Divider()
            }
            
            upIcon?.renderingMode(.template)
                .foregroundColor(.secondary)
            
            HStack() {
                leftIcon?.renderingMode(.template)
                    
                    .foregroundColor(.secondary)
                
                ZStack {
                    // 中央は直径280の場合は140:140
                    BigRing(
                        bigRingNormalBackgroundColor: bigRingNormalBackgroundColor,  bigRingDarkBackgroundColor: bigRingDarkBackgroundColor, 
                        bigRingStrokeColor: bigRingStrokeColor,
                        bigRingDiameter: bigRingDiameter).gesture(dragGesture)
                    
                    SmallRing(smallRingDiameter: self.smallRingDiameter, subRingColor: subRingColor).offset(x: smallRingLocationX, y: smallRingLocationY)
                }
                
                rightIcon?.renderingMode(.template)
                    .foregroundColor(.secondary)
            }
            
            downIcon?.renderingMode(.template)
                .foregroundColor(.secondary)
            
            if isDebug {
                Divider()
                
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
        OMJoystick(isDebug: true) { (joyStickState, stickPosition)  in
        }
    }
}
