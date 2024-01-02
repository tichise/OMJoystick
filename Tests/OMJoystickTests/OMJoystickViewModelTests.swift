import XCTest
@testable import OMJoystick

final class OMJoystickViewModelTests: XCTestCase {
        
    var viewModel: OMJoystickViewModel!
    
    override func setUp() {
        viewModel = OMJoystickViewModel(smallRingRadius: 20, bigRingRadius: 30)
    }
    
    func testGetJoyStickState() {
        viewModel.locationX = 0
        viewModel.locationY = 0
        XCTAssertEqual(viewModel.getJoyStickState(), JoyStickState.center)
        
        viewModel.locationX = 0
        viewModel.locationY = 100
        XCTAssertEqual(viewModel.getJoyStickState(), JoyStickState.down)
        viewModel.locationX = 0
        viewModel.locationY = -100
        XCTAssertEqual(viewModel.getJoyStickState(), JoyStickState.up)
        
        viewModel.locationX = 100
        viewModel.locationY = 0
        XCTAssertEqual(viewModel.getJoyStickState(), JoyStickState.right)
        
        viewModel.locationX = -100
        viewModel.locationY = 0
        XCTAssertEqual(viewModel.getJoyStickState(), JoyStickState.left)
    }
}
