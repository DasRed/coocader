import Foundation

/// product identifier
extension Store {
    /// all static identifier
    enum ProductIdentifier: String {
        case RemoveAd = "removead"
        case TimeLimitEndlessGame = "endlessgame"
    }

    /// buy a identifier
    func buy(identifier: ProductIdentifier, completion: () -> Void = {}) {
        self.buy(identifier.rawValue, completion: completion)
    }
}