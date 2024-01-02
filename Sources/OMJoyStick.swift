//
//  OMJoystick.swift
//  Omicro
//
//  Created by tichise on 2020年8月9日 20/08/09.
//  Copyright © 2020 tichise. All rights reserved.
//

import SwiftUI

public struct OMJoystick: View {
    
    // ViewModelをオブジェクトとして保持
    @ObservedObject var viewModel: OMJoystickViewModel
    
    // ジョイスティックの各種色設定
    var iconColor: Color
    var subRingColor: Color
    var bigRingNormalBackgroundColor: Color
    var bigRingDarkBackgroundColor: Color
    var bigRingStrokeColor: Color

    // アイコン画像の設定
    var leftIcon: Image?
    var rightIcon: Image?
    var upIcon: Image?
    var downIcon: Image?
    
    // デバッグモードのフラグ
    var isDebug = false
    
    // ジョイスティックの操作結果を伝えるコールバック関数
    public var completionHandler: ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)
    
    // アイコンのパディング設定
    let iconPadding: CGFloat = 10
    
    // ドラッグジェスチャーの定義
    var dragGesture: some Gesture {
        // ドラッグジェスチャーの設定。最小距離を0に設定している
        // minimumDistanceが1以上だとタッチイベントを一切拾わないので注意
        DragGesture(minimumDistance: 0)
            .onChanged{ value in
                // ドラッグ位置と原点との距離を計算
                let distance = viewModel.org.getDistance(otherPoint: value.location)
                
                // 小さい円の中心までの制限距離
                let smallRingLimitCenter: CGFloat = viewModel.bigRingRadius - viewModel.smallRingRadius
                
                if (distance <= smallRingLimitCenter) {
                    // 円の範囲内であれば位置を更新
                    viewModel.locationX = value.location.x
                    viewModel.locationY = value.location.y
                } else {
                    // 円の範囲外であれば、円上の点を計算
                    let radian = viewModel.org.getRadian(pointOnCircle: value.location)
                    let pointOnCircle = viewModel.org.getPointOnCircle(radius: smallRingLimitCenter, radian: radian)
                    
                    viewModel.locationX = pointOnCircle.x
                    viewModel.locationY = pointOnCircle.y
                }
                
                // ジョイスティックの状態を更新
                if viewModel.joyStickState != viewModel.getJoyStickState() {
                    viewModel.joyStickState = viewModel.getJoyStickState()
                }
                
                // コールバック関数を実行
                self.completionHandler(viewModel.joyStickState,  viewModel.stickPosition)
        }
        .onEnded{ value in
            // ドラッグ終了時の位置と状態をリセット
            viewModel.locationX = viewModel.bigRingDiameter/2
            viewModel.locationY = viewModel.bigRingDiameter/2
            
            viewModel.locationX = viewModel.bigRingRadius
            viewModel.locationY = viewModel.bigRingRadius
            
            viewModel.joyStickState = JoyStickState.center
            
            // コールバック関数を実行
            self.completionHandler(viewModel.joyStickState,  viewModel.stickPosition)
        }
    }
    
    // コンストラクタ
    public init(isDebug: Bool = false, iconSetting: IconSetting? = nil, colorSetting: ColorSetting, smallRingRadius: CGFloat = 50, bigRingRadius: CGFloat = 140, isOctantLinesVisible: Bool = false,
        completionHandler: @escaping ((_ joyStickState: JoyStickState, _ stickPosition: CGPoint) -> Void)) {
        
        // 各種設定値の初期化
        self.isDebug = isDebug
        self.iconColor = colorSetting.iconColor
        self.subRingColor = colorSetting.subRingColor
        self.bigRingNormalBackgroundColor = colorSetting.bigRingNormalBackgroundColor
        self.bigRingDarkBackgroundColor = colorSetting.bigRingDarkBackgroundColor
        self.bigRingStrokeColor = colorSetting.bigRingStrokeColor
        
        // アイコンの設定
        if let iconSetting = iconSetting {
            self.leftIcon = iconSetting.leftIcon
            self.rightIcon = iconSetting.rightIcon
            self.upIcon = iconSetting.upIcon
            self.downIcon = iconSetting.downIcon
        }
        
        // コールバック関数とViewModelの初期化
        self.completionHandler = completionHandler
        self.viewModel = OMJoystickViewModel(smallRingRadius: smallRingRadius, bigRingRadius: bigRingRadius)
        self.viewModel.isOctantLinesVisible = isOctantLinesVisible
    }
    
    // ビューの本体
    public var body: some View {
        // VStackを使用してビューを垂直に積み重ねる
        VStack {
            // デバッグモード時の表示
            if isDebug {
                VStack {
                    HStack(spacing: 15) {
                        // スティックのX座標を表示
                        Text(viewModel.stickPosition.x.text()).font(.body)
                        Text(":").font(.body)
                        // スティックのY座標を表示
                        Text(viewModel.stickPosition.y.text()).font(.body)
                    }
                }.padding(10)
            }
            
            // 上方向アイコンの表示設定
            upIcon?.renderingMode(.template)
                .foregroundColor(iconColor).padding(iconPadding)
            
            // 水平方向アイコンとジョイスティック本体の表示
            HStack() {
                // 左方向アイコンの表示設定
                leftIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
                
                // ジョイスティックの中心円（BigRing）と小さい円（SmallRing）の表示
                ZStack {
                    BigRing(
                        bigRingNormalBackgroundColor: bigRingNormalBackgroundColor,  bigRingDarkBackgroundColor: bigRingDarkBackgroundColor,
                        bigRingStrokeColor: bigRingStrokeColor,
                        bigRingDiameter: viewModel.bigRingDiameter).environmentObject(viewModel).gesture(dragGesture)
                    
                    SmallRing(smallRingDiameter: viewModel.smallRingDiameter, subRingColor: subRingColor).offset(x: viewModel.smallRingLocationX, y: viewModel.smallRingLocationY).environmentObject(viewModel).allowsHitTesting(false)
                }
                
                // 右方向アイコンの表示設定
                rightIcon?.renderingMode(.template)
                    .foregroundColor(iconColor).padding(iconPadding)
            }
            
            // 下方向アイコンの表示設定
            downIcon?.renderingMode(.template)
                .foregroundColor(iconColor).padding(iconPadding)
            
            // デバッグモード時のジョイスティックの状態表示
            if isDebug {
                HStack(spacing: 15) {
                    Text(viewModel.joyStickState.rawValue).font(.body)
                }
            }
        }.padding(40) // 全体のパディング設定
    }
}

// プレビュープロバイダー1
struct OMJoystick_Previews1: PreviewProvider {
    static var previews: some View {
        // プレビューのレイアウト設定
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                // ジョイスティックのプレビュー表示
                OMJoystick(isDebug: true, colorSetting: ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow, iconColor: .red)) { (joyStickState, stickPosition) in
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
    }
}

// プレビュープロバイダー2
struct OMJoystick_Previews2: PreviewProvider {
    static var previews: some View {
        // プレビューのレイアウト設定
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                // ジョイスティックのプレビュー表示
                OMJoystick(isDebug: true,  colorSetting: ColorSetting(iconColor: .orange), smallRingRadius: 70, bigRingRadius: 120, isOctantLinesVisible: true
                ) { (joyStickState, stickPosition)  in
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
    }
}
