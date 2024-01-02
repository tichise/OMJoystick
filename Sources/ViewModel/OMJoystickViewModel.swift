//
//  OMJoystickViewModel.swift
//
//
//  Created by tichise on 2024/01/01.
//

import SwiftUI

/// OMJoystickViewModel
class OMJoystickViewModel: ObservableObject {
    public init(isOctantLinesVisible: Bool = false, smallRingRadius: CGFloat, bigRingRadius: CGFloat) {
        self.isOctantLinesVisible = isOctantLinesVisible
        self.smallRingRadius = smallRingRadius
        self.bigRingRadius = bigRingRadius
    }
    
    @Published var joyStickState: JoyStickState = .center

    // 8等分のラインを表示するか制御する
    public var isOctantLinesVisible: Bool = false
    
    public var stickPosition: CGPoint {
        let stickPositionX = floor(locationX - bigRingRadius)
        
        let stickPositionY = floor((locationY - bigRingRadius) < 0 ? -1 * (locationY - bigRingRadius) : locationY - bigRingRadius)
                
        return CGPoint(x: stickPositionX, y: stickPositionY)
    }
    
    @Published var locationX: CGFloat = 0
    @Published var locationY: CGFloat = 0
    
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
    
    public func getJoyStickState() -> JoyStickState {
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

    public var org: CGPoint {
        return CGPoint(x: self.bigRingRadius, y: self.bigRingRadius)
    }
}
