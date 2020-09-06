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
    
    var body: some View {
        Circle().fill(Color.primary)
                           .frame(width: smallRingDiameter, height: smallRingDiameter)
    }
}

struct BigRing: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Circle().stroke(Color.primary, lineWidth: 10)
            .frame(width: 280, height: 280)
            
            Circle().fill(colorScheme == .dark ? Color.black : Color.white)
            .frame(width: 280, height: 280)
        }
    }
}

extension CGFloat {
    func text() -> String {
        return String(format: "%.00f", Float(self))
    }
}

enum JoyStickState: String {
    case up
    case down
    case left
    case right
    case center
}

struct OMJoystick: View {
    
    var isDebug = false
    
    @State var joyStickState: JoyStickState = .center
        {
        didSet {
            self.completionHandler(self.joyStickState)
        }
    }
    var completionHandler: ((_ joyStickState: JoyStickState) -> Void)

    var iconSize: CGFloat = 40
    
    var org = CGPoint(x: 140, y: 140)
    
    @State var locationX: CGFloat = 140
    @State var locationY: CGFloat = 140
    
    
    var smallRingDiameter: CGFloat {
        return smallRingRadius*2
    }
    
    var bigRingDiameter: CGFloat {
        return bigRingRadius*2
    }
    
    let smallRingRadius: CGFloat = 50
    let bigRingRadius: CGFloat = 140

    
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
            
            self.locationX = 140
            self.locationY = 140
            
            self.joyStickState = .center
            
            self.completionHandler(self.joyStickState)
        }
    }

    var body: some View {
        
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
            
            Image(icon: .expandLess48px, size: iconSize).renderingMode(.template)
            .foregroundColor(.secondary)

            HStack() {
                Image(icon: .rotateLeft48px, size: iconSize).renderingMode(.template)
                .foregroundColor(.secondary)
                
                ZStack {
                     // 中央は直径280の場合は140:140
                    BigRing().gesture(dragGesture)
                    
                    SmallRing(smallRingDiameter: self.smallRingDiameter).offset(x: smallRingLocationX, y: smallRingLocationY)
                }

                Image(icon: .rotateRight48px, size: iconSize).renderingMode(.template)
                .foregroundColor(.secondary)
            }
            
            Image(icon: .expandMore48px, size: iconSize).renderingMode(.template)
            .foregroundColor(.secondary)
            
            if isDebug {
                Divider()
                
                HStack(spacing: 15) {
                    Text(joyStickState.rawValue).font(.body)
                }
            }
        }.padding(40)
    }
}

struct OMJoystick_Previews: PreviewProvider {
    static var previews: some View {
        OMJoystick(isDebug: true, completionHandler: { (joyStickState) in
            print(joyStickState.rawValue)
        })
    }
}
