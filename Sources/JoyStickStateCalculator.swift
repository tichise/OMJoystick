//
//  JoyStickStateCalculator.swift
//
//
//  Created by tichise on 2024/01/06.
//

import Foundation

class JoyStickStateCalculator {
    
    /// 八等分ジョイスティックの状態を取得する
    /// - Parameters:
    /// - angle: ジョイスティックの角度
    /// - stength: ジョイスティックの強さ
    /// - Returns: JoyStickState
    static func getJoyStickStateOctant(angle: CGFloat, stength: Int) -> JoyStickState {
        var state: JoyStickState = .center
        
        // 8等分の場合
        if (angle >= 337.5 || angle < 22.5) {
            state = .up
        } else if (angle >= 22.5 && angle < 67.5) {
            state = .rightUp
        } else if (angle >= 67.5 && angle < 112.5) {
            state = .right
        } else if (angle >= 112.5 && angle < 157.5) {
            state = .rightDown
        } else if (angle >= 157.5 && angle < 202.5) {
            state = .down
        } else if (angle >= 202.5 && angle < 247.5) {
            state = .leftDown
        } else if (angle >= 247.5 && angle < 292.5) {
            state = .left
        } else if (angle >= 292.5 && angle < 337.5) {
            state = .leftUp
        }
                
        return state
    }
    
    /// 四等分ジョイスティックの状態を取得する
    /// - Parameters:
    /// - stickPosition: ジョイスティックの位置
    /// - stength: ジョイスティックの強さ
    /// - Returns: JoyStickState
    static func getJoyStickStateQuadrant(stickPosition: CGPoint, stength: Int) -> JoyStickState {
        var state: JoyStickState = .center
        
        let xValue = stickPosition.x
        let yValue = stickPosition.y

        // 4等分の場合
        if (abs(xValue) > abs(yValue)) {
            state = xValue < 0 ? .left : .right
        } else if (abs(yValue) > abs(xValue)) {
            state = yValue < 0 ? .down : .up
        }
        
        return state
    }
    
    // 原点からの距離を取得
    public static func getDistanceFromOrigin(stickPosition: CGPoint) -> Int {
        let result = sqrt(stickPosition.x * stickPosition.x + stickPosition.y * stickPosition.y)
        return Int(result)
    }

    // 真上からの角度（0から360度）を取得
    public static func getAngle(stickPosition: CGPoint) -> CGFloat {
        // atan2を使用して角度を計算
        let point = CGPoint(x: stickPosition.x, y: stickPosition.y)

        // ラジアンから角度に変換
        let angleInRadians = atan2(point.x, point.y)

        // 角度をラジアンに変換
        var angleInDegrees = angleInRadians * 180 / .pi

        // 角度を0〜360度に変換
        if (angleInDegrees < 0) {
            angleInDegrees += 360
        }

        return angleInDegrees
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
