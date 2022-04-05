# UnleashSwiftUI
📦 Package containing non native SwiftUI components
## Description
🚀 We all love SwiftUI, because it allows us to create graphical interfaces quickly. But sometimes it happens that some components are not available for SwiftUI. So I decided to create this collection of ready-to-use components.
Each component is fully documented with examples as well. You can consult it via Xcode as you are already used to, by pressing <kbd>⌥</kbd> or <kbd>⌘ + Show Quick Help</kbd>.
## Installation
📲 Open your Xcode Project then go to File > Add Packages... and paste this repository link. After that you need to import inside your source code.
```swift
import UnleashSwiftUI
```
## Components available
- Non modal experience introduced in iOS 15 only for UIKit (sheet with detents)
```swift
.sheet(isPresented:detents:showGrabber:scrollingExpand:undimmed:edgeRadius:onDismiss:content:)
```
- Photo Picker (PHPickerViewController from PhotosUI)
```swift
.photoPicker(isPresented:images:limit:)
```
- Camera (UIImagePickerController from UIKit)
```swift
.camera(isPresented:image:device:flashMode:)
```
