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

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick() { (joyStickState) in
                    TILogger().info(joyStickState.rawValue)
                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
                
                OMJoystick(isDebug: true, leftIcon: Image(systemSymbol: .rotateLeft), smallRingRadius: 70, bigRingRadius: 120
                ) { (joyStickState) in
                    TILogger().info(joyStickState.rawValue)

                }.frame(width: geometry.size.width-40, height: geometry.size.width-40)
            }.background(Color.white)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
