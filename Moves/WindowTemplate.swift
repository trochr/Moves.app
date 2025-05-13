import Foundation

struct WindowTemplate {
  let position: String
  let relativeWidth: CGFloat?
  let relativeHeight: CGFloat?
  let action: String?

  static let templates: [String: WindowTemplate] = [
    // Toggle/Maximize templates
    "toggle-fullscreen": WindowTemplate(
      position: "topLeft", relativeWidth: 1.0, relativeHeight: 1.0, action: "toggleFullscreen"),
    "maximize": WindowTemplate(
      position: "topLeft", relativeWidth: 1.0, relativeHeight: 1.0, action: nil),
    "maximize-height": WindowTemplate(
      position: "topLeft", relativeWidth: nil, relativeHeight: 1.0, action: nil),
    "maximize-width": WindowTemplate(
      position: "topLeft", relativeWidth: 1.0, relativeHeight: nil, action: nil),

    // Half screen templates
    "left-half": WindowTemplate(
      position: "centerLeft", relativeWidth: 0.5, relativeHeight: 1.0, action: nil),
    "right-half": WindowTemplate(
      position: "centerRight", relativeWidth: 0.5, relativeHeight: 1.0, action: nil),
    "bottom-half": WindowTemplate(
      position: "bottomLeft", relativeWidth: 1.0, relativeHeight: 0.5, action: nil),
    "top-half": WindowTemplate(
      position: "topLeft", relativeWidth: 1.0, relativeHeight: 0.5, action: nil),

    // Center and simple movements
    "center": WindowTemplate(
      position: "center", relativeWidth: nil, relativeHeight: nil, action: nil),
    "move-up": WindowTemplate(
      position: "topLeft", relativeWidth: nil, relativeHeight: nil, action: nil),
    "move-down": WindowTemplate(
      position: "bottomLeft", relativeWidth: nil, relativeHeight: nil, action: nil),
    "move-left": WindowTemplate(
      position: "centerLeft", relativeWidth: nil, relativeHeight: nil, action: nil),
    "move-right": WindowTemplate(
      position: "centerRight", relativeWidth: nil, relativeHeight: nil, action: nil),

    // Restore and reasonable size
    "restore": WindowTemplate(
      position: "center", relativeWidth: 0.6, relativeHeight: 0.6, action: nil),
    "reasonable-size": WindowTemplate(
      position: "center", relativeWidth: 0.6, relativeHeight: 0.6, action: nil),

    // Display management - requires special handling
    "previous-display": WindowTemplate(
      position: "center", relativeWidth: nil, relativeHeight: nil, action: "previousDisplay"),
    "next-display": WindowTemplate(
      position: "center", relativeWidth: nil, relativeHeight: nil, action: "nextDisplay"),

    // Thirds
    "first-third": WindowTemplate(
      position: "centerLeft", relativeWidth: 0.33, relativeHeight: 1.0, action: nil),
    "first-two-thirds": WindowTemplate(
      position: "centerLeft", relativeWidth: 0.67, relativeHeight: 1.0, action: nil),
    "center-third": WindowTemplate(
      position: "center", relativeWidth: 0.33, relativeHeight: 1.0, action: nil),
    "last-two-thirds": WindowTemplate(
      position: "centerRight", relativeWidth: 0.67, relativeHeight: 1.0, action: nil),
    "last-third": WindowTemplate(
      position: "centerRight", relativeWidth: 0.33, relativeHeight: 1.0, action: nil),

    // Fourths - second/third need special positioning
    "first-fourth": WindowTemplate(
      position: "centerLeft", relativeWidth: 0.25, relativeHeight: 1.0, action: nil),
    "second-fourth": WindowTemplate(
      position: "centerLeft", relativeWidth: 0.25, relativeHeight: 1.0, action: "secondFourth"),
    "third-fourth": WindowTemplate(
      position: "centerRight", relativeWidth: 0.25, relativeHeight: 1.0, action: "thirdFourth"),
    "last-fourth": WindowTemplate(
      position: "centerRight", relativeWidth: 0.25, relativeHeight: 1.0, action: nil),

    // Quarters (corners)
    "top-left-quarter": WindowTemplate(
      position: "topLeft", relativeWidth: 0.5, relativeHeight: 0.5, action: nil),
    "top-right-quarter": WindowTemplate(
      position: "topRight", relativeWidth: 0.5, relativeHeight: 0.5, action: nil),
    "bottom-left-quarter": WindowTemplate(
      position: "bottomLeft", relativeWidth: 0.5, relativeHeight: 0.5, action: nil),
    "bottom-right-quarter": WindowTemplate(
      position: "bottomRight", relativeWidth: 0.5, relativeHeight: 0.5, action: nil),

    // Sixths - center ones need specific positioning
    "top-left-sixth": WindowTemplate(
      position: "topLeft", relativeWidth: 0.33, relativeHeight: 0.5, action: nil),
    "top-center-sixth": WindowTemplate(
      position: "topLeft", relativeWidth: 0.33, relativeHeight: 0.5, action: "topCenterSixth"),
    "top-right-sixth": WindowTemplate(
      position: "topRight", relativeWidth: 0.33, relativeHeight: 0.5, action: nil),
    "bottom-left-sixth": WindowTemplate(
      position: "bottomLeft", relativeWidth: 0.33, relativeHeight: 0.5, action: nil),
    "bottom-center-sixth": WindowTemplate(
      position: "bottomLeft", relativeWidth: 0.33, relativeHeight: 0.5, action: "bottomCenterSixth"),
    "bottom-right-sixth": WindowTemplate(
      position: "bottomRight", relativeWidth: 0.33, relativeHeight: 0.5, action: nil),
  ]
}
