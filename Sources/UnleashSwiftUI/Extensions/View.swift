//
//  View.swift
//
//  Created by Alessandro Di Maio on 01/04/22.
//

import SwiftUI

@available(iOS 15.0, macCatalyst 15.0, *)
extension View {
    /// Presents a sheet with optional customizations when a binding to a Boolean value that you provide is true.
    ///
    /// Use this method when you want to present a modal view to the
    /// user when a Boolean value you provide is true. The example
    /// below displays show how you can achieve a non modal experience view with a grabber:
    ///
    ///     struct NonModalExperience: View {
    ///         @State private var isPresented = false
    ///         var body: some View {
    ///             VStack {
    ///                 Button("Open") {
    ///                     isPresented.toggle()
    ///                 }
    ///             }
    ///             .sheet(
    ///                 isPresented: $isPresented,
    ///                 detents: [.medium()],
    ///                 showGrabber: true,
    ///                 undimmed: .medium,
    ///                 onDismiss: didDismiss
    ///             ) {
    ///                 Color.mint
    ///             }
    ///         }
    ///         func didDismiss() {
    ///             // Handle the dismissing action.
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///   to present the sheet that you create in the modifier's `content` closure.
    ///   - detents: Array of detents that the sheet may rest at.
    ///   This array must have at least one element.
    ///   Detents must be specified in order from smallest to largest height.
    ///   - grabber: Set true to show a grabber at the top of the sheet.
    ///   - scrollingExpand: If there is a larger detent to expand to than the selected detent,
    ///   and a descendent scroll view is scrolled to top.
    ///   this controls whether scrolling down will expand to a larger detent.
    ///   - undimmed: The identifier of the largest detent that is not dimmed.
    ///   When nil or the identifier is not found in detents, all detents are dimmed.
    ///   When you provide an identifier and the detent is medium you can interact with the partially covered view.
    ///   - edgeRadius: The radius applied on top edges. Any value greater than 50 will be ignored.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure that returns the content of the sheet.
    public func sheet<Content>(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent],
        showGrabber: Bool = false,
        scrollingExpand: Bool = false,
        undimmed: UISheetPresentationController.Detent.Identifier? = nil,
        edgeRadius: CGFloat? = nil,
        onDismiss: (() -> Void)? = nil,
        content: @escaping () -> Content
    ) -> some View where Content : View {
        ZStack {
            DetentsSheet(
                isPresented: isPresented,
                detents: detents,
                grabber: showGrabber,
                scrollingExpand: scrollingExpand,
                undimmed: undimmed,
                edgeRadius: edgeRadius,
                onDismiss: onDismiss,
                content: content
            )
            self
        }
    }
}

@available(iOS 14.0, macCatalyst 14.0, *)
extension View {
    /// Presents a photo picker when a binding to a Boolean value that you provide is true.
    ///
    /// Use this method when you want to present a photo picker to the
    /// user when a Boolean value you provide is true. The example
    /// below displays how you can show some photos after picking
    /// with a limit selection of 3 photos:
    ///
    ///     struct PhotosCollection: View {
    ///         @State private var imagePickerPresented = false
    ///         @State private var images: [UIImage] = []
    ///         var body: some View {
    ///             NavigationView {
    ///                 ScrollView {
    ///                     ForEach(images, id:\.self) { image in
    ///                         Image(uiImage: image)
    ///                             .resizable()
    ///                             .scaledToFit()
    ///                             .frame(width: 140, height: 140, alignment: .center)
    ///                         Divider()
    ///                     }
    ///                 }
    ///                 .navigationTitle("Photo Picker")
    ///                 .toolbar {
    ///                     ToolbarItem {
    ///                         Button {
    ///                             imagePickerPresented.toggle()
    ///                         } label: {
    ///                             Image(systemName: "photo.on.rectangle")
    ///                                 .font(.title2)
    ///                         }
    ///                     }
    ///                 }
    ///             }.photoPicker(isPresented: $imagePickerPresented, images: $images, limit: 3)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///   to present the photo picker.
    ///   - images: Array of photos that picker fills.
    ///   - limit: Limit number of selectable photos. Default value equal to 1
    public func photoPicker(
        isPresented: Binding<Bool>,
        images: Binding<[UIImage]>,
        limit: Int = 1
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            PhotoPicker(isPresented: isPresented, images: images, limit: limit)
                .ignoresSafeArea(.container, edges: .all)
        }
    }
}

@available(iOS 14.0, macCatalyst 14.0, *)
extension View {
    /// Presents a camera in fullscreen mode when a binding to a Boolean value that you provide is true.
    ///
    /// Use this method when you want to present a camera to the
    /// user when a Boolean value you provide is true. The example
    /// below displays how you can show a camera with front device pre-selected:
    ///
    ///     struct CameraView: View {
    ///         @State private var isPresented = false
    ///         @State private var image: UIImage?
    ///         var body: some View {
    ///             NavigationView {
    ///                 VStack {
    ///                     Button("Open camera") {
    ///                         isPresented.toggle()
    ///                     }
    ///                     if let image = image {
    ///                         Image(uiImage: image)
    ///                             .resizable()
    ///                             .scaledToFit()
    ///                             .frame(width: 150, height: 150, alignment: .center)
    ///                     }
    ///                 }
    ///             }.camera(isPresented: $isPresented, image: $image, device: .front)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether
    ///   to present the camera.
    ///   - images: A UIImage to fill with camera.
    ///   - device: Front or Rear camera. By default is set to .rear
    ///   - flash: For specifying the flash mode. By default is set to .auto
    public func camera(
        isPresented: Binding<Bool>,
        image: Binding<UIImage?>,
        device: UIImagePickerController.CameraDevice = .rear,
        flashMode: UIImagePickerController.CameraFlashMode = .auto
    ) -> some View {
        self.fullScreenCover(isPresented: isPresented) {
            Camera(isPresented: isPresented, image: image, device: device, flashMode: flashMode)
                .ignoresSafeArea(.container, edges: .vertical)
        }
    }
}
