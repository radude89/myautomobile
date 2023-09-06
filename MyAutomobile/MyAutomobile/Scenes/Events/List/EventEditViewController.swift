/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The event edit view controller to add events to Calendar.
*/

import SwiftUI
import EventKitUI

struct EventEditViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    typealias UIViewControllerType = EKEventEditViewController
    
    private let event: EKEvent
    private let eventStore: EKEventStore
    private let onComplete: (String?) -> Void
    
    init(event: EKEvent, eventStore: EKEventStore, onComplete: @escaping (String?) -> Void) {
        self.event = event
        self.eventStore = eventStore
        self.onComplete = onComplete
    }
    
    /// Create an event edit view controller, then configure it with the specified event and event store.
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        let controller = EKEventEditViewController()
        controller.eventStore = eventStore
        controller.event = event
        controller.editViewDelegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, EKEventEditViewDelegate {
        var parent: EventEditViewController
        
        init(_ controller: EventEditViewController) {
            self.parent = controller
        }
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            parent.presentationMode.wrappedValue.dismiss()
            parent.onComplete(controller.event?.eventIdentifier)
        }
    }
}
