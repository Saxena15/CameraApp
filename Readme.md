# Image Capture & Storage App

A simple iOS application that allows users to capture multiple images using the device’s camera, display them in a list view, and save them to a local database (Realm).

## Features

- Capture images using `AVCaptureSession`.
- Display captured images in a list view.
- Save and retrieve images from a local database using Realm.

## Tech Stack

- **UIKit**: For building the user interface.
- **AVFoundation**: To access the device camera and capture images.
- **Realm**: For local data persistence, enabling fast and easy saving and retrieving of images.

## Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/ImageCaptureApp.git
   cd SpyneAssignment
   ```

2. **Open in Xcode**
   - Open the `.xcodeproj` or `.xcworkspace` file in Xcode.

3. **Install Dependencies**
   - Packages are added as Swift Package Manager(SPM). 
   - Search for Realm dependency and add to main project.

4. **Run the App**
   - Select a simulator or device and press **Run** (⌘R) in Xcode.

## How It Works

### 1. Camera Integration

- The app uses `AVCaptureSession` and `AVCapturePhotoOutput` to access the device’s camera and capture images.
- A custom camera interface allows users to preview and capture images.
- Captured images are saved temporarily in-memory and displayed in a list view.

### 2. Image Display in a List

- After capturing, each image is added to a `UITableView` with a custom `UITableViewCell` displaying the image and other details (e.g., timestamp).
- Users can scroll through the list to see all captured images.

### 3. Local Database Storage with Realm

- The app integrates Realm to save and persist captured images locally.
- Each image is saved as a `Realm Object` with fields for the image data and capture timestamp.
- The app retrieves and displays saved images upon launch.

## Usage

1. **Capture an Image**
   - Launch the app, and the camera interface appears.
   - Tap the **Capture** button to take a photo.
   - The captured photo is saved to the list and stored in Realm.

2. **View Captured Images**
   - Navigate to the list view to see all captured images.
   - Images are saved and retrieved from the Realm database on subsequent app launches.

## Code Structure

- **`CameraViewController`**: Handles the camera interface, including previewing and capturing images with `AVCaptureSession`.
- **`ImageListViewController`**: Displays captured images in a table view.
- **`ImageModel`**: A Realm object model that defines the properties for each saved image, including the image data and timestamp.
- **`RealmManager`**: Handles interactions with the Realm database, such as saving and retrieving images.

## Dependencies

- [Realm](https://realm.io/docs/swift/latest/): A mobile database to provide persistence for captured images.

## Requirements

- **iOS 13.0+**
- **Xcode 12+**
- **Swift 5.0**

## Permissions

The app requires the following permissions to function:

- **Camera Access**: Required to capture images with the device’s camera.

Ensure to add this key in `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access to capture images.</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>App needs access to photos</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>App needs access to photos</string>
```

## Demo

[App Demo.](https://drive.google.com/file/d/1xWC4dNn0OGsCOqRoq7tp6di_vrME9Mvd/view?usp=sharing)

## Future Improvements

- Add image filters to enhance the captured images.
- Implement an option to delete images from Realm.
- Add support for photo gallery access to import images.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
