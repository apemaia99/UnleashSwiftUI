//
//  View.swift
//
//  Created by Alessandro Di Maio on 01/04/22.
//

import SwiftUI

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
    ///                     isPresented = true
    ///                 }
    ///             }
    ///             .sheet(
    ///                 isPresented: $isPresented,
    ///                 detents: [.medium()],
    ///                 showGrabber: true,
    ///                 onDismiss: didDismiss
    ///             ) {
    ///                 EmptyView()
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
    public func sheet<Content: View>(
        isPresented: Binding<Bool>,
        detents: [UISheetPresentationController.Detent],
        showGrabber: Bool = false,
        scrollingExpand: Bool = false,
        undimmed: UISheetPresentationController.Detent.Identifier? = nil,
        edgeRadius: CGFloat? = nil,
        onDismiss: (() -> Void)? = nil,
        content: @escaping () -> Content
    ) -> some View {
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
