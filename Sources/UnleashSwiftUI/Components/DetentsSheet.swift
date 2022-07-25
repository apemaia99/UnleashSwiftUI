//
//  DetentsSheet.swift
//
//  Created by Alessandro Di Maio on 31/03/22.
//

import SwiftUI

@available(iOS 15.0, macCatalyst 15.0, *)
struct DetentsSheet<Content>: UIViewRepresentable where Content: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    typealias UIViewType = UIView
    @Binding var isPresented: Bool
    private let detents: [UISheetPresentationController.Detent]
    private let grabber: Bool
    private let scrollingExpand: Bool
    private let undimmed: UISheetPresentationController.Detent.Identifier?
    private let edgeRadius: CGFloat?
    private let onDismiss: (() -> Void)?
    private let content: Content
    
    init(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent],
        grabber: Bool,
        scrollingExpand: Bool,
        undimmed: UISheetPresentationController.Detent.Identifier?,
        edgeRadius: CGFloat?,
        onDismiss: (() -> Void)?,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.detents = detents
        self.grabber = grabber
        self.scrollingExpand = scrollingExpand
        self.undimmed = undimmed
        self.edgeRadius = edgeRadius
        self._isPresented = isPresented
        self.onDismiss = onDismiss
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        //ViewController for UISheetPresentationController
        //HostingController for SwiftUI content
        let viewController = UIViewController()
        print(colorScheme)
        let hostingController = UIHostingController(
            rootView: content
                .preferredColorScheme(colorScheme)
                .ignoresSafeArea(.container, edges: .all)
        )
        
        viewController.addChild(hostingController)
        viewController.view.addSubview(hostingController.view)
        
        //Constraints for HostingController
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.leftAnchor.constraint(equalTo: viewController.view.leftAnchor).isActive = true
        hostingController.view.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: viewController.view.rightAnchor).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        hostingController.didMove(toParent: viewController)
        
        //Non modal experience with UISheetPresentationController customization (customization are available in a new modifier)
        if let sheetController = viewController.sheetPresentationController {
            sheetController.detents = detents
            sheetController.prefersScrollingExpandsWhenScrolledToEdge = scrollingExpand
            sheetController.prefersGrabberVisible = grabber
            sheetController.largestUndimmedDetentIdentifier = undimmed
            if let edgeRadius = edgeRadius {
                sheetController.preferredCornerRadius = (edgeRadius <= 50 ? edgeRadius : 50)
            }
            if detents.contains(.large()) {
                sheetController.prefersEdgeAttachedInCompactHeight = true
                sheetController.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            }
        }
        
        //Coordinator attach
        viewController.presentationController?.delegate = context.coordinator
        
        //Check for viewController presentation
        //Dismiss is necessary  because a SwiftUI hierarchy from HostingController can set isPresented to false
        if isPresented {
            uiView.window?.rootViewController?.present(viewController, animated: true)
        } else {
            uiView.window?.rootViewController?.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

@available(iOS 15.0, macCatalyst 15.0, *)
extension DetentsSheet {
    class Coordinator: NSObject, UISheetPresentationControllerDelegate {
        
        private let parent: DetentsSheet
        
        init(_ parent: DetentsSheet) {
            self.parent = parent
        }
        //event delegate for controller dismissing from UIKit hierarchy and run onDismiss closure
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            self.parent.isPresented = false
            if let onDismiss = self.parent.onDismiss {
                onDismiss()
            }
        }
    }
}
