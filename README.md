### OMJoystick ![CocoaPods Version](https://img.shields.io/cocoapods/v/OMJoystick.svg?style=flat) ![Platform](https://img.shields.io/cocoapods/p/OMJoystick.svg?style=flat) ![License](https://img.shields.io/cocoapods/l/OMJoystick.svg?style=flat)

This is the JoyStick UI library for SwiftUI.

### Image
![image](https://user-images.githubusercontent.com/43707/92985960-424fa400-f4f2-11ea-9d6e-10f6cdb40179.png)

### Examples

#### Swift

Simple
```html
import SwiftUI
import OMJoystick

struct ContentView: View {

    var body: some View {
        OMJoystick(colorSetting: ColorSetting()) { (joyStickState, stickPosition) in
        }
    }
}
```

Customize

```html
import SwiftUI
import OMJoystick
import SFSafeSymbols

struct ContentView: View {        
    let iconSetting = IconSetting(
        leftIcon: Image(systemSymbol: .arrowLeft),
        rightIcon: Image(systemSymbol: .arrowRight),
        upIcon: Image(systemSymbol:.arrowUp),
        downIcon: Image(systemSymbol: .arrowDown)
    )
    
    let colorSetting = ColorSetting(subRingColor: .red, bigRingNormalBackgroundColor: .green, bigRingDarkBackgroundColor: .blue, bigRingStrokeColor: .yellow)
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 5) {
                OMJoystick(isDebug: true, iconSetting: self.iconSetting,  colorSetting: ColorSetting(), smallRingRadius: 70, bigRingRadius: 120
                ) { (joyStickState, stickPosition)  in
                    
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
```


### Installation (CocoaPods)
`pod 'OMJoystick'`

### CocoaPods URL
[OMJoystick on CocoaPods.org](https://cocoapods.org/pods/OMJoystick)

### License
OMJoystick is available under the MIT license. See the LICENSE file for more info.
