//
//  OMJoystickViewModel.swift
//
//
//  Created by tichise on 2024/01/01.
//

import SwiftUI

// OMJoystickViewModel
class OMJoystickViewModel: ObservableObject {
    // イニシャライザ
    public init(isOctantLinesVisible: Bool = false, smallRingRadius: CGFloat, bigRingRadius: CGFloat) {
        self.isOctantLinesVisible = isOctantLinesVisible  // 8等分のラインを表示するかどうか
        self.smallRingRadius = smallRingRadius // 小さいリングの半径
        self.bigRingRadius = bigRingRadius // 大きいリングの半径
        
        self.locationX = bigRingRadius  // X座標の初期位置
        self.locationY = bigRingRadius  // Y座標の初期位置
    }
    
    @Published var joyStickState: JoyStickState = .center  // ジョイスティックの状態（初期値は中央）

    // 8等分のラインを表示するかどうかのフラグ
    public var isOctantLinesVisible: Bool = false
    
    // ジョイスティックの位置を表すプロパティ
    public var stickPosition: CGPoint {
        let stickPositionX = floor(locationX - bigRingRadius)
        let stickPositionY = floor(locationY - bigRingRadius)
                
        return CGPoint(x: stickPositionX, y: stickPositionY)
    }
    
    @Published var locationX: CGFloat = 0  // X座標
    @Published var locationY: CGFloat = 0  // Y座標
    
    // 小さいリングの直径を計算するプロパティ
    var smallRingDiameter: CGFloat {
        return smallRingRadius * 2
    }
    
    // 大きいリングの直径を計算するプロパティ
    var bigRingDiameter: CGFloat {
        return bigRingRadius * 2
    }

    // 小さいリングの半径を計算するプロパティ
    var smallRingRadius: CGFloat

    // 大きいリングの半径を計算するプロパティ
    var bigRingRadius: CGFloat
    
    // 小さいリングのX座標の位置を計算するプロパティ
    var smallRingLocationX: CGFloat {
        return locationX - bigRingRadius
    }
    
    // 小さいリングのY座標の位置を計算するプロパティ
    var smallRingLocationY: CGFloat {
        return locationY - bigRingRadius
    }
    
    // ジョイスティックの状態を計算するメソッド
    public func getJoyStickState() -> JoyStickState {
        var state: JoyStickState = .center  // 初期状態は中央
        
        let xValue = locationX - bigRingRadius  // X座標の差
        let yValue = locationY - bigRingRadius  // Y座標の差
        
        if (abs(xValue) > abs(yValue)) {
            state = xValue < 0 ? .left : .right  // 左または右
        } else if (abs(yValue) > abs(xValue)) {
            state = yValue < 0 ? .up : .down  // 上または下
        }
        
        return state
    }

    // ジョイスティックの原点を表すプロパティ
    public var org: CGPoint {
        return CGPoint(x: self.bigRingRadius, y: self.bigRingRadius)
    }
}
