import XCTest
@testable import OMJoystick

final class OMJoystickViewModelTests: XCTestCase {
        
    var viewModel: OMJoystickViewModel!
    
    override func setUp() {
        viewModel = OMJoystickViewModel()
    }
    
    func testGetJoyStickState() {
        viewModel.locationX = 0
        viewModel.locationY = 0
        XCTAssertEqual(viewModel.getJoyStickState(), .none)
        
        viewModel.locationX = 0
        viewModel.locationY = 100
        XCTAssertEqual(viewModel.getJoyStickState(), .up)
        
        viewModel.locationX = 0
        viewModel.locationY = -100
        XCTAssertEqual(viewModel.getJoyStickState(), .down)
        
        viewModel.locationX = 100
        viewModel.locationY = 0
        XCTAssertEqual(viewModel.getJoyStickState(), .right)
        
        viewModel.locationX = -100
        viewModel.locationY = 0
        XCTAssertEqual(viewModel.getJoyStickState(), .left)
        
        viewModel.locationX = 100
        viewModel.locationY = 100
        XCTAssertEqual(viewModel.getJoyStickState(), .rightUp)
        
        viewModel.locationX = -100
        viewModel.locationY = 100
        XCTAssertEqual(viewModel.getJoyStickState(), .leftUp)
        
        viewModel.locationX = 100
        viewModel.locationY = -100
        XCTAssertEqual(viewModel.getJoyStickState(), .rightDown)
        
        viewModel.locationX = -100
        viewModel.locationY = -100
        XCTAssertEqual(viewModel.getJoyStickState(), .leftDown)
    }
}
