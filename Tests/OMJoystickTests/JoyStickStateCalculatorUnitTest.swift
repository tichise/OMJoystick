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
        
        XCTAssertEqual(JoyStickStateCalculator.getJoyStickState(locationX: 0, locationY: 0, bigRingRadius: bingRingRadius, isOctantLinesVisible: false), JoyStickState.center)
        XCTAssertEqual(JoyStickStateCalculator.getJoyStickState(locationX: 30, locationY: 30, bigRingRadius: bingRingRadius, isOctantLinesVisible: true), JoyStickState.rightUp)

        
    }

}
