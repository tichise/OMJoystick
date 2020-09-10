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
        leftIcon: Image(systemSymbol: .rotateLeft),
        rightIcon: Image(systemSymbol: .rotateLeft),
        upIcon: Image(systemSymbol:.rotateLeft),
        downIcon: Image(systemSymbol: .rotateLeft)
    )
    
    let colorSetting = ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true, colorSetting: self.colorSetting) { (joyStickState, stickPosition) in
                    TILogger().info(joyStickState.rawValue)
                    TILogger().info(stickPosition)
                    
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
                
                OMJoystick(isDebug: true, iconSetting: self.iconSetting,  colorSetting: ColorSetting(), smallRingRadius: 70, bigRingRadius: 120
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
