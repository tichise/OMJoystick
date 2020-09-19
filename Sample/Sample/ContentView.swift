//
//  ContentView.swift
//  Sample
//
//  Created by tichise on 2020年9月6日 20/09/06.
//  Copyright © 2020 tichise. All rights reserved.
//

import SwiftUI
import OMJoystick
import SFSafeSymbols
import TILogger

struct ContentView: View {
    let iconSize: CGFloat = 40
        
    let iconSetting = IconSetting(
        leftIcon: Image(systemSymbol: .arrowLeft),
        rightIcon: Image(systemSymbol: .arrowRight),
        upIcon: Image(systemSymbol:.arrowUp),
        downIcon: Image(systemSymbol: .arrowDown)
    )
    
    let colorSetting = ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow, iconColor: .red)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true, colorSetting: self.colorSetting) { (joyStickState, stickPosition) in
                    TILogger().info(joyStickState.rawValue)
                    TILogger().info(stickPosition)
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
                
                OMJoystick(isDebug: true, iconSetting: self.iconSetting,  colorSetting: ColorSetting(iconColor: .orange), smallRingRadius: 70, bigRingRadius: 120
                ) { (joyStickState, stickPosition)  in
                    TILogger().info(joyStickState.rawValue)
                    TILogger().info(stickPosition)
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
