//
//  JoyStickStateCalculator.swift
//
//
//  Created by tichise on 2024/01/06.
//

import Foundation

class JoyStickStateCalculator {

    /// ジョイスティックの状態を取得する
    /// - Parameters:
    ///  - locationX: ジョイスティックのX座標
    ///  - locationY: ジョイスティックのY座標
    ///  - bigRingRadius: 大きいリングの半径
    ///  - isOctantLinesVisible: 8等分のラインを表示するか制御する
    static func getJoyStickState(locationX: CGFloat, locationY: CGFloat, bigRingRadius: CGFloat, isOctantLinesVisible: Bool) -> JoyStickState {
        var state: JoyStickState = .center
        
        let xValue = locationX - bigRingRadius
        let yValue = locationY - bigRingRadius

        if isOctantLinesVisible {
            // 8等分の場合
                if abs(xValue) > abs(yValue) {
                    state = xValue < 0 ? .left : .right
                    if abs(yValue) > bigRingRadius / 2 {
                        state = xValue < 0 ? (yValue < 0 ? .leftUp : .leftDown) : (yValue < 0 ? .rightUp : .rightDown)
                    }
                } else {
                    state = yValue < 0 ? .up : .down
                    if abs(xValue) > bigRingRadius / 2 {
                        state = yValue < 0 ? (xValue < 0 ? .leftUp : .rightUp) : (xValue < 0 ? .leftDown : .rightDown)
                    }
                }
        } else {
            // 4等分の場合
            if (abs(xValue) > abs(yValue)) {
                state = xValue < 0 ? .left : .right
            } else if (abs(yValue) > abs(xValue)) {
                state = yValue < 0 ? .up : .down
            }
        }
        
        return state
    }
}

/// JoyStickState
public enum JoyStickState: String {
    case up
    case down
    case left
    case right
    case center
    case leftUp
    case leftDown
    case rightUp
    case rightDown
}
