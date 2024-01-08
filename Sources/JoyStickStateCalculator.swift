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

        // 8等分の場合
        if isOctantLinesVisible {
            // このコードブロックは、2つの値 xValue と yValue の絶対値を比較し、
            // それに基づいて state 変数を設定します。このロジックは、
            // 一種の方向制御（例えば、ゲーム内のキャラクター移動やUIのインタラクション）に使われる可能性があります。

            if abs(xValue) > abs(yValue) {
                // xValue の絶対値が yValue の絶対値より大きい場合

                // 基本的な左右の状態を設定
                state = xValue < 0 ? .left : .right

                if abs(yValue) > bigRingRadius / 2 {
                    // yValue の絶対値が bigRingRadius の半分より大きい場合
                    
                    // 斜めの方向を計算して state を更新
                    // xValue < 0 の場合、左方向（leftUp または leftDown）
                    // xValue >= 0 の場合、右方向（rightUp または rightDown）
                    state = xValue < 0 ? (yValue < 0 ? .leftUp : .leftDown) : (yValue < 0 ? .rightUp : .rightDown)
                }

            } else {
                // xValue の絶対値が yValue の絶対値より小さいまたは等しい場合

                // 基本的な上下の状態を設定
                state = yValue < 0 ? .up : .down

                if abs(xValue) > bigRingRadius / 2 {
                    // xValue の絶対値が bigRingRadius の半分より大きい場合
                    // 斜めの方向を計算して state を更新
                    // yValue < 0 の場合、上方向（leftUp または rightUp）
                    // yValue >= 0 の場合、下方向（leftDown または rightDown）
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
