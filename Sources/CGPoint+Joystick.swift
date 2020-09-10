//
//  CGPoint+Joystick.swift
//  OMJoystick
//
//  Created by tichise on 2020年9月6日 20/09/06.
//

import UIKit

extension CGPoint {
    
    func pointOnCircle(radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = self.x + radius * cos(angle)
        let y = self.y + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
    
    func angleToPoint(pointOnCircle: CGPoint) -> CGFloat {
        
        let originX = pointOnCircle.x - self.x
        let originY = pointOnCircle.y - self.y
        var radians = atan2(originY, originX)
        
        while radians < 0 {
            radians += CGFloat(2 * Double.pi)
        }
        
        return radians
    }
    
    func distanceToPoint(otherPoint: CGPoint) -> CGFloat {
        return sqrt(pow((otherPoint.x - x), 2) + pow((otherPoint.y - y), 2))
    }
}
