//
//  CGPoint+Joystick.swift
//  OMJoystick
//
//  Created by tichise on 2020年9月6日 20/09/06.
//

import UIKit

extension CGPoint {
    
    /// Get point on circle
    func getPointOnCircle(radius: CGFloat, radian: CGFloat) -> CGPoint {
        let x = self.x + radius * cos(radian)
        let y = self.y + radius * sin(radian)
        
        return CGPoint(x: x, y: y)
    }
    
    /// Get radian from point on circle
    func getRadian(pointOnCircle: CGPoint) -> CGFloat {
        
        // 円周率を直接記述する
        let piValue: Double = 3.14159265358979
        
        let originX = pointOnCircle.x - self.x
        let originY = pointOnCircle.y - self.y
        var radian = atan2(originY, originX)
        
        while radian < 0 {
            radian += CGFloat(2 * piValue)
        }
        
        return radian
    }
    
    /// Get distance from other point
    func getDistance(otherPoint: CGPoint) -> CGFloat {
        return sqrt(pow((otherPoint.x - x), 2) + pow((otherPoint.y - y), 2))
    }
}
