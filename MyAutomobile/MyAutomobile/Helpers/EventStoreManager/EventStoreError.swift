/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Comforms to the error protocol.
*/

import Foundation

enum EventStoreError: Error {
    case denied
    case restricted
    case unknown
}
