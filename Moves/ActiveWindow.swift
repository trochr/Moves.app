import AXSwift
import Cocoa

class ActiveWindow {
  static func getFrontmost() -> AccessibilityElement? {
    guard let app = NSWorkspace.shared.frontmostApplication else { return nil }

    do {
      if let appElement = Application(forProcessID: app.processIdentifier) {
        let windows: [AXUIElement]? = try appElement.attribute(.windows)
        if let windows = windows, let mainWindow = windows.first {
          return AccessibilityElement(ref: UIElement(mainWindow))
        }
      }
    } catch {
      return nil
    }

    return nil
  }

  static func applyTemplate(_ templateKey: String) {
    guard let template = WindowTemplate.templates[templateKey] else { return }

    // Convert relative dimensions to absolute if needed
    let screenRect = NSScreen.main?.visibleFrame ?? .zero
    var width: CGFloat? = nil
    var height: CGFloat? = nil

    if let relativeWidth = template.relativeWidth {
      width = screenRect.width * relativeWidth
    }

    if let relativeHeight = template.relativeHeight {
      height = screenRect.height * relativeHeight
    }

    // Apply the position and size
    if let action = template.action {
      performAction(action)
    } else {
      position(template.position, width: width, height: height)
    }
  }

  static func performAction(_ action: String) {
    guard let window = getFrontmost() else { return }
    let screenRect = NSScreen.main?.visibleFrame ?? .zero
    let windowPosition = window.position ?? .zero
    let windowSize = window.size ?? .zero

    switch action {
    case "toggleFullscreen":
      // Check if window is taking full screen and toggle
      if windowSize.width >= screenRect.width && windowSize.height >= screenRect.height {
        // Use reasonable size if currently full screen
        let size = CGSize(width: screenRect.width * 0.6, height: screenRect.height * 0.6)
        // Just use position to handle both moves and resize in correct order
        position("center", width: size.width, height: size.height)
      } else {
        // Go full screen
        window.moveTo(CGPoint(x: screenRect.minX, y: screenRect.minY))
        window.resizeTo(CGSize(width: screenRect.width, height: screenRect.height))
      }

    case "previousDisplay", "nextDisplay":
      // Multi-display handling would go here
      // Currently just ensuring the window is visible on the main display
      if windowPosition.x < screenRect.minX || windowPosition.x + windowSize.width > screenRect.maxX
        || windowPosition.y < screenRect.minY
        || windowPosition.y + windowSize.height > screenRect.maxY
      {
        position("center", width: windowSize.width, height: windowSize.height)
      }

    case "secondFourth":
      let width = screenRect.width * 0.25
      window.moveTo(CGPoint(x: screenRect.minX + width, y: screenRect.minY))
      window.resizeTo(CGSize(width: width, height: screenRect.height))

    case "thirdFourth":
      let width = screenRect.width * 0.25
      window.moveTo(CGPoint(x: screenRect.minX + width * 2, y: screenRect.minY))
      window.resizeTo(CGSize(width: width, height: screenRect.height))

    case "topCenterSixth":
      let width = screenRect.width * 0.33
      let height = screenRect.height * 0.5
      window.moveTo(CGPoint(x: screenRect.minX + width, y: screenRect.maxY - height))
      window.resizeTo(CGSize(width: width, height: height))

    case "bottomCenterSixth":
      let width = screenRect.width * 0.33
      let height = screenRect.height * 0.5
      window.moveTo(CGPoint(x: screenRect.minX + width, y: screenRect.minY))
      window.resizeTo(CGSize(width: width, height: height))

    default:
      break
    }
  }

  static func position(
    _ command: String, width: CGFloat? = nil, height: CGFloat? = nil, xOffset: CGFloat = 0,
    yOffset: CGFloat = 0
  ) {
    guard let window = getFrontmost() else { return }

    let screenRect = NSScreen.main?.visibleFrame ?? .zero

    // Get target size - either specified or current
    let windowSize: CGSize
    if let width = width, let height = height {
      windowSize = CGSize(width: width, height: height)
    } else {
      windowSize = window.size ?? .zero
    }

    // Calculate the position based on target size
    var newPosition: CGPoint = .zero

    switch command {
    case "centerRight":
      newPosition = CGPoint(
        x: screenRect.maxX - windowSize.width + xOffset,
        y: screenRect.midY - windowSize.height / 2 + yOffset
      )
    case "center":
      newPosition = CGPoint(
        x: screenRect.midX - windowSize.width / 2 + xOffset,
        y: screenRect.midY - windowSize.height / 2 + yOffset
      )
    case "centerLeft":
      newPosition = CGPoint(
        x: screenRect.minX + xOffset,
        y: screenRect.midY - windowSize.height / 2 + yOffset
      )
    case "topRight":
      newPosition = CGPoint(
        x: screenRect.maxX - windowSize.width + xOffset,
        y: screenRect.maxY - windowSize.height + yOffset
      )
    case "topLeft":
      newPosition = CGPoint(
        x: screenRect.minX + xOffset,
        y: screenRect.maxY - windowSize.height + yOffset
      )
    case "bottomRight":
      newPosition = CGPoint(
        x: screenRect.maxX - windowSize.width + xOffset,
        y: screenRect.minY + yOffset
      )
    case "bottomLeft":
      newPosition = CGPoint(
        x: screenRect.minX + xOffset,
        y: screenRect.minY + yOffset
      )
    default:
      break
    }

    // First move to the correct position
    window.moveTo(newPosition)

    // Then resize if needed - this way we ensure the window is positioned correctly
    // regardless of its size
    if let width = width, let height = height {
      let size = CGSize(width: width, height: height)
      window.resizeTo(size)
    }
  }
}
