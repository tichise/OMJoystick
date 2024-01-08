//
//  OMJoystickViewModel.swift
//
//
//  Created by tichise on 2024/01/01.
//

import SwiftUI

/// OMJoystickViewModel
class OMJoystickViewModel: ObservableObject {
    // 8等分のラインを表示するか制御する
    public var isOctantLinesVisible: Bool
    
    public init(isOctantLinesVisible: Bool = false) {
        self.isOctantLinesVisible = isOctantLinesVisible
    }
}
