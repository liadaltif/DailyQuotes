import Foundation

// TODO: Enable the App Group capability for the app and widget targets using this identifier.
let appGroupID = "group.com.yourcompany.yourapp"

/// Returns the URL for the shared background image file in the App Group container.
/// The file is located at <AppGroup>/WidgetImages/background.jpg
func sharedBackgroundURL() -> URL? {
    let fm = FileManager.default
    guard let container = fm.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
        print("AppGroup: unable to resolve container for \(appGroupID)")
        return nil
    }
    let dir = container.appendingPathComponent("WidgetImages", isDirectory: true)
    return dir.appendingPathComponent("background.jpg")
}
