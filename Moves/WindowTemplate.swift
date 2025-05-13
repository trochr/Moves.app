import Foundation

// Position options for window positioning
enum WindowPosition: String, CaseIterable {
  case center
  case centerRight
  case centerLeft
  case topRight
  case topLeft
  case bottomRight
  case bottomLeft
  case relative  // Keeps current position
}

// Actions for special window operations
enum WindowAction: String, CaseIterable {
  case toggleFullscreen
  case maximizeHeight
  case maximizeWidth
  case previousDisplay
  case nextDisplay
  case secondFourth
  case thirdFourth
  case topCenterSixth
  case bottomCenterSixth
}

// Size specification for windows
enum WindowSize {
  case relative(width: CGFloat?, height: CGFloat?)
  case absolute(width: CGFloat?, height: CGFloat?)

  // Convert to absolute pixels based on screen size
  func toAbsoluteSize(for screenRect: CGRect) -> (width: CGFloat?, height: CGFloat?) {
    let screenSize = screenRect.size
    switch self {
    case .relative(let width, let height):
      let absoluteWidth = width.map { $0 * screenSize.width }
      let absoluteHeight = height.map { $0 * screenSize.height }
      return (absoluteWidth, absoluteHeight)

    case .absolute(let width, let height):
      return (width, height)
    }
  }
}

// A window operation is either a position+size or a special action
enum WindowOperation {
  case position(position: WindowPosition, size: WindowSize)
  case action(WindowAction)
}

// Template types for consistent typing and usage
enum TemplateType: String, CaseIterable {
  // Toggle/Maximize templates
  case toggleFullscreen = "toggle-fullscreen"
  case maximize
  case maximizeHeight = "maximize-height"
  case maximizeWidth = "maximize-width"

  // Half screen templates
  case leftHalf = "left-half"
  case rightHalf = "right-half"
  case bottomHalf = "bottom-half"
  case topHalf = "top-half"

  // Center and simple movements
  case center
  case moveUp = "move-up"
  case moveDown = "move-down"
  case moveLeft = "move-left"
  case moveRight = "move-right"

  // Restore and reasonable size
  case restore
  case reasonableSize = "reasonable-size"

  // Display management
  case previousDisplay = "previous-display"
  case nextDisplay = "next-display"

  // Thirds
  case firstThird = "first-third"
  case firstTwoThirds = "first-two-thirds"
  case centerThird = "center-third"
  case lastTwoThirds = "last-two-thirds"
  case lastThird = "last-third"

  // Fourths
  case firstFourth = "first-fourth"
  case secondFourth = "second-fourth"
  case thirdFourth = "third-fourth"
  case lastFourth = "last-fourth"

  // Quarters (corners)
  case topLeftQuarter = "top-left-quarter"
  case topRightQuarter = "top-right-quarter"
  case bottomLeftQuarter = "bottom-left-quarter"
  case bottomRightQuarter = "bottom-right-quarter"

  // Sixths
  case topLeftSixth = "top-left-sixth"
  case topCenterSixth = "top-center-sixth"
  case topRightSixth = "top-right-sixth"
  case bottomLeftSixth = "bottom-left-sixth"
  case bottomCenterSixth = "bottom-center-sixth"
  case bottomRightSixth = "bottom-right-sixth"

  // Get the window operation for this template type
  var operation: WindowOperation {
    switch self {
    // Toggle/Maximize templates
    case .toggleFullscreen:
      return .action(.toggleFullscreen)
    case .maximize:
      return .position(position: .topLeft, size: .relative(width: 1.0, height: 1.0))
    case .maximizeHeight:
      return .action(.maximizeHeight)
    case .maximizeWidth:
      return .action(.maximizeWidth)

    // Half screen templates
    case .leftHalf:
      return .position(position: .centerLeft, size: .relative(width: 0.5, height: 1.0))
    case .rightHalf:
      return .position(position: .centerRight, size: .relative(width: 0.5, height: 1.0))
    case .bottomHalf:
      return .position(position: .bottomLeft, size: .relative(width: 1.0, height: 0.5))
    case .topHalf:
      return .position(position: .topLeft, size: .relative(width: 1.0, height: 0.5))

    // Center and simple movements
    case .center:
      return .position(position: .center, size: .relative(width: nil, height: nil))
    case .moveUp:
      return .position(position: .topLeft, size: .relative(width: nil, height: nil))
    case .moveDown:
      return .position(position: .bottomLeft, size: .relative(width: nil, height: nil))
    case .moveLeft:
      return .position(position: .centerLeft, size: .relative(width: nil, height: nil))
    case .moveRight:
      return .position(position: .centerRight, size: .relative(width: nil, height: nil))

    // Restore and reasonable size
    case .restore, .reasonableSize:
      return .position(position: .center, size: .relative(width: 0.6, height: 0.6))

    // Display management
    case .previousDisplay:
      return .action(.previousDisplay)
    case .nextDisplay:
      return .action(.nextDisplay)

    // Thirds
    case .firstThird:
      return .position(position: .centerLeft, size: .relative(width: 0.33, height: 1.0))
    case .firstTwoThirds:
      return .position(position: .centerLeft, size: .relative(width: 0.67, height: 1.0))
    case .centerThird:
      return .position(position: .center, size: .relative(width: 0.33, height: 1.0))
    case .lastTwoThirds:
      return .position(position: .centerRight, size: .relative(width: 0.67, height: 1.0))
    case .lastThird:
      return .position(position: .centerRight, size: .relative(width: 0.33, height: 1.0))

    // Fourths
    case .firstFourth:
      return .position(position: .centerLeft, size: .relative(width: 0.25, height: 1.0))
    case .secondFourth:
      return .action(.secondFourth)
    case .thirdFourth:
      return .action(.thirdFourth)
    case .lastFourth:
      return .position(position: .centerRight, size: .relative(width: 0.25, height: 1.0))

    // Quarters (corners)
    case .topLeftQuarter:
      return .position(position: .topLeft, size: .relative(width: 0.5, height: 0.5))
    case .topRightQuarter:
      return .position(position: .topRight, size: .relative(width: 0.5, height: 0.5))
    case .bottomLeftQuarter:
      return .position(position: .bottomLeft, size: .relative(width: 0.5, height: 0.5))
    case .bottomRightQuarter:
      return .position(position: .bottomRight, size: .relative(width: 0.5, height: 0.5))

    // Sixths
    case .topLeftSixth:
      return .position(position: .topLeft, size: .relative(width: 0.33, height: 0.5))
    case .topCenterSixth:
      return .action(.topCenterSixth)
    case .topRightSixth:
      return .position(position: .topRight, size: .relative(width: 0.33, height: 0.5))
    case .bottomLeftSixth:
      return .position(position: .bottomLeft, size: .relative(width: 0.33, height: 0.5))
    case .bottomCenterSixth:
      return .action(.bottomCenterSixth)
    case .bottomRightSixth:
      return .position(position: .bottomRight, size: .relative(width: 0.33, height: 0.5))
    }
  }
}
