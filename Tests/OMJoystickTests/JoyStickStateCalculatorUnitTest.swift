//
//  JoyStickStateCalculatorUnitTest.swift
//
//
//  Created by tichise on 2024/01/06.
//

import XCTest
@testable import OMJoystick

final class JoyStickStateCalculatorUnitTest: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testGetJoyStickState() throws {
        let bingRingRadius = CGFloat(100)
    }

    func testDistanceFromOrigin() {
        XCTAssertEqual(JoyStickStateCalculator.getDistanceFromOrigin(stickPosition: CGPoint(x: 0, y: 0)), 0)
        XCTAssertEqual(JoyStickStateCalculator.getDistanceFromOrigin(stickPosition: CGPoint(x: 100, y: 0)), 100)
        XCTAssertEqual(JoyStickStateCalculator.getDistanceFromOrigin(stickPosition: CGPoint(x: 0, y: 100)), 100)
        XCTAssertEqual(JoyStickStateCalculator.getDistanceFromOrigin(stickPosition: CGPoint(x: -100, y: -100)), 141)
    }
    
    func testAngle() {
        XCTAssertEqual(JoyStickStateCalculator.getAngle(stickPosition: CGPoint(x:  0, y: 0)), 0)
        XCTAssertEqual(JoyStickStateCalculator.getAngle(stickPosition: CGPoint(x:  0, y: 180)), 0)
        XCTAssertEqual(JoyStickStateCalculator.getAngle(stickPosition: CGPoint(x:  45, y: 45)), 45)
        XCTAssertEqual(JoyStickStateCalculator.getAngle(stickPosition: CGPoint(x:  90, y: 0)), 90)
        XCTAssertEqual(JoyStickStateCalculator.getAngle(stickPosition: CGPoint(x:  -90, y: 0)), 270)
        XCTAssertEqual(JoyStickStateCalculator.getAngle(stickPosition: CGPoint(x:  -45, y: -45)), 225)
    }
}
