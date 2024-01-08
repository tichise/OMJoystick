//
//  JoyStickStateCalculator.swift
//
//
//  Created by tichise on 2024/01/06.
//

import Foundation

class JoyStickStateCalculator {
    
    /// locationXとlocationYをもとにangleを返す
    /// - Parameters:
    /// - locationX: ジョイスティックのX座標
    /// - locationY: ジョイスティックのY座標
    /// - Returns: 角度
    /// - Note: 角度はラジアンで返す
    /// - Note: 0度は上方向で、時計回りに増加する
    /// - Note: 8等分の場合は、0, 45, 90, 135, 180, 225, 270, 315, 360度のいずれかになる
    /// - Note: 8等分の場合は、角度を45度ずつずらす
    /// - Note: 8等分の場合は、45度ずつずらすための値を返す
    static func getAngle(locationX: CGFloat, locationY: CGFloat) -> CGFloat {
        // atan2を使用して角度を計算
        let angle = atan2(locationX, locationY)
        
        return angle
    }

    /// 八等分ジョイスティックの状態を取得する
    /// - Parameters:
    /// - stickPosition: ジョイスティックの位置
    /// - stength: ジョイスティックの強さ
    /// - Returns: JoyStickState
    static func getJoyStickStateOctant(stickPosition: CGPoint, stength: CGFloat) -> JoyStickState {
        var state: JoyStickState = .center
                
        return state
    }
    
    /// 四等分ジョイスティックの状態を取得する
    /// - Parameters:
    /// - stickPosition: ジョイスティックの位置
    /// - stength: ジョイスティックの強さ
    /// - Returns: JoyStickState
    static func getJoyStickStateQuadrant(stickPosition: CGPoint, stength: CGFloat) -> JoyStickState {
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
    
    // strengthをメソッドにした
    public static func getStrength(stickPosition: CGPoint) -> CGFloat {
        return sqrt(stickPosition.x * stickPosition.x + stickPosition.y * stickPosition.y)
    }
    
    // angleをメソッドにした
    public static func getAngle(stickPosition: CGPoint) -> CGFloat {
        // atan2を使用して角度を計算
        let point = CGPoint(x: stickPosition.x, y: stickPosition.y)
        
        let angleInRadians = atan2(point.x, point.y)
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
