import UIKit
import SwiftUI
import WidgetKit
import PhotosUI

// Replace with your real app group identifier
private let appGroupID = "group.com.liadaltif.DailyQuotes"

// Where the widget background image will be saved
func sharedBackgroundURL() -> URL? {
    guard let containerURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: appGroupID
    ) else { return nil }
    return containerURL.appendingPathComponent("widget-background.jpg")
}

/// Downscales the image so its largest dimension is roughly the provided max value.
private func downscaledImage(from image: UIImage, maxDimension: CGFloat = 1800) -> UIImage? {
    let size = image.size
    let maxCurrentDimension = max(size.width, size.height)
    guard maxCurrentDimension > maxDimension else { return image }
    let scale = maxDimension / maxCurrentDimension
    let newSize = CGSize(width: size.width * scale, height: size.height * scale)
    let renderer = UIGraphicsImageRenderer(size: newSize)
    return renderer.image { _ in
        image.draw(in: CGRect(origin: .zero, size: newSize))
    }
}

/// Saves the given image to the shared App Group container for widget use.
/// - Returns: The URL of the saved image or nil on failure.
func saveWidgetBackgroundImage(_ image: UIImage) -> URL? {
    guard let url = sharedBackgroundURL() else { return nil }
    let fm = FileManager.default
    let dir = url.deletingLastPathComponent()

    do {
        try fm.createDirectory(at: dir, withIntermediateDirectories: true)
    } catch {
        print("ImageSave: directory creation failed", error)
        return nil
    }

    guard let scaled = downscaledImage(from: image),
          let data = scaled.jpegData(compressionQuality: 0.87) else {
        print("ImageSave: downscaling or JPEG conversion failed")
        return nil
    }

    do {
        try data.write(to: url, options: [.atomic])
        print("ImageSave: wrote file to", url.path)
        let defaults = UserDefaults(suiteName: appGroupID)
        defaults?.set(true, forKey: "hasBackgroundImage")
        WidgetCenter.shared.reloadAllTimelines()
        return url
    } catch {
        print("ImageSave: write failed", error)
        return nil
    }
}

/// Simple PHPicker wrapper that loads a single image and saves it for the widget.
struct BackgroundImagePicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ controller: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            provider.loadObject(ofClass: UIImage.self) { object, _ in
                if let image = object as? UIImage {
                    _ = saveWidgetBackgroundImage(image)
                }
            }
        }
    }
}
