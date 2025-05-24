import AXSwift
import Cocoa
import Defaults

class WindowHandler {
  var monitors: [Any?] = []
  var window: AccessibilityElement?

  var intention: Intention = .idle {
    didSet { intentionChanged(self.intention) }
  }

  deinit {
    removeMonitors()
  }

  func intentionChanged(_ intention: Intention) {
    removeMonitors()

    if intention == .idle {
      self.window = nil
      return
    }

    let loc = Mouse.location()
    guard let window = AccessibilityElement.at(loc)?.window else { return }

    let app = window.application

    // App is excluded?

    if let path = applicationPath(app: app),
      Defaults[.excludedApplicationPaths].contains(path)
    {
      return
    }

    self.window = window

    if Defaults[.bringToFront] {
      try? app?.setAttribute(.frontmost, value: true)
      try? window.ref.setAttribute(.main, value: true)
    }

    self.monitors.append(
      NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { event in
        self.mouseMoved(event)
      }
    )
    self.monitors.append(
      NSEvent.addLocalMonitorForEvents(matching: .mouseMoved) { event in
        self.mouseMoved(event)
        return event
      }
    )
  }

  private func getBundleID(for axApplication: AXUIElement) -> String? {
    var pid: pid_t = 0
    if AXUIElementGetPid(axApplication, &pid) == .success {
      if let app = NSRunningApplication(processIdentifier: pid) {
        return app.bundleIdentifier
      }
    }
    return nil
  }

  private func applicationPath(app maybeApp: Application?) -> String? {
    guard let app = maybeApp else {
      print("no app")
      return nil
    }
    guard let bundleId: String = getBundleID(for: app.element) else {
      print("no bundle id")
      return nil
    }
    guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleId) else {
      print("no url")
      return nil
    }
    let path = url.path
    return path.hasSuffix("/") ? path : path.appending("/")
  }

  private func mouseMoved(_ event: NSEvent) {
    switch intention {
    case .move: move(event)
    case .resize: resize(event)
    case .idle:
      assertionFailure("mouseMoved obseved while ignoring")
    }
  }

  private func removeMonitors() {
    monitors.forEach { (monitor) in
      guard let m = monitor else { return }
      NSEvent.removeMonitor(m)
    }
    self.monitors = []
  }

  private func move(_ event: NSEvent) {
    guard let window = self.window else { return }
    guard let pos = window.position else { return }
    let dest = CGPoint(x: pos.x + event.deltaX, y: pos.y + event.deltaY)
    window.moveTo(dest)
  }

  private func resize(_ event: NSEvent) {
    guard let window = self.window else { return }
    guard let size = window.size else { return }
    guard let pos = window.position else { return }
    let mouseY = NSEvent.mouseLocation.y
    let mouseX = NSEvent.mouseLocation.x
    let windowTop = pos.y + size.height
    let windowBottom = pos.y
    let windowLeft = pos.x
    let windowRight = pos.x + size.width
    // Determine which border is closer: top or bottom
    let distanceToTop = abs(mouseY - windowTop)
    let distanceToBottom = abs(mouseY - windowBottom)
    // Determine which border is closer: left or right
    let distanceToLeft = abs(mouseX - windowLeft)
    let distanceToRight = abs(mouseX - windowRight)
    var newHeight = size.height
    var newY = pos.y
    if distanceToTop > distanceToBottom {
      // Closer to top: resize from top edge
      newHeight = size.height + event.deltaY
      newY = pos.y
    } else {
      // Closer to bottom: resize from bottom edge
      newHeight = size.height - event.deltaY
      newY = pos.y + event.deltaY
    }
    var newWidth = size.width
    var newX = pos.x
    if distanceToLeft < distanceToRight {
      // Closer to left: resize from left edge
      newWidth = size.width - event.deltaX
      newX = pos.x + event.deltaX
    } else {
      // Closer to right: resize from right edge
      newWidth = size.width + event.deltaX
      newX = pos.x
    }
    window.moveTo(CGPoint(x: newX, y: newY))
    window.resizeTo(CGSize(width: newWidth, height: newHeight))
  }

}
