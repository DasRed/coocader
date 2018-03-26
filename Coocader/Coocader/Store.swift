import Foundation
import StoreKit

class Store: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver, EventManagerProtocol {
    // events
    enum EventType: String, EventTypeProtocol {
        case InteractionStarted = "store.interaction.started"
        case InteractionEnded = "store.interaction.ended"

        case ProductFetched = "store.product.fechted" /// data contains the identifier
        case ProductWasBuyed = "store.productWasBuyed" /// data contains the identifier
        case ProductWasRestored = "store.productWasRestored" /// data contains the identifier
    }

    /// shared instance
    class var shared: Store {
        struct Static {
            static let instance: Store = Store()
        }
        return Static.instance
    }

    /// the products
    private var products: [String: SKProduct] = [:]

    // init
    override init() {
        super.init()

        if (SKPaymentQueue.canMakePayments() == false) {
            SCLAlertView().showError("In-App Käufe sind deaktiviert".localized, subTitle: "Bitte aktiviere In-App Käufe in den Einstellungen".localized)
        }

        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }

    /// buy a identifier
    func buy(identifier: String, completion: () -> Void = {}) {
        self.trigger(EventType.InteractionStarted)

        /// request
        if (self.products[identifier] == nil) {
            self.buyWithRequest(identifier, completion: completion)
            return
        }

        let listener = EventListener(callback: {})
        listener.replaceCallback({(event: Event) -> Void in
            // has a identifiert
            guard let identiferEvent = event.data as? String else {
                return
            }

            /// is this identifier
            guard identiferEvent == identifier else {
                return
            }

            // do not listen anymore
            self.removeListener(listener)

            // buyed
            completion()
        })

        // listen to product fetched event
        self.addListener(EventType.ProductWasBuyed, listener)

        /// start payment
        #if !STORE_PASSTHROUGH
            let payment = SKPayment(product: self.products[identifier]!)
            SKPaymentQueue.defaultQueue().addPayment(payment)
        #else
            self.trigger(EventType.ProductWasBuyed, identifier)
            self.trigger(EventType.InteractionEnded)
        #endif
    }

    /// starts a buy with request the product
    private func buyWithRequest(identifier: String, completion: () -> Void = {}) {
        let listener = EventListener(callback: {})
        listener.replaceCallback({(event: Event) -> Void in
            // has a identifiert
            guard let identiferEvent = event.data as? String else {
                return
            }

            /// is this identifier
            guard identiferEvent == identifier else {
                return
            }

            // do not listen anymore
            self.removeListener(listener)

            // buy again
            self.buy(identifier, completion: completion)
        })

        // listen to product fetched event
        self.addListener(EventType.ProductFetched, listener)

        // request the product
        self.requestProduct(identifier)
    }

    /// requests a product
    private func requestProduct(identifier: String) {
        let identifierFull = NSBundle.mainBundle().bundleIdentifier! + "." + identifier

        guard SKPaymentQueue.canMakePayments() == true else {
            return
        }

        let request = SKProductsRequest(productIdentifiers: Set([identifierFull]))
        request.delegate = self
        request.start()
    }

    // callback on products request
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        for product in response.products {
            let identifier = product.productIdentifier.stringByReplacingOccurrencesOfString(NSBundle.mainBundle().bundleIdentifier! + ".", withString: "")

            self.products[identifier] = product
            self.trigger(EventType.ProductFetched, identifier)
        }

        // failed
        if (response.products.count == 0 && response.invalidProductIdentifiers.count != 0) {
            self.trigger(EventType.InteractionEnded)
        }
    }
    
    // payment queue
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        #if !STORE_PASSTHROUGH
            for transaction in transactions {
                let identifier = transaction.payment.productIdentifier.stringByReplacingOccurrencesOfString(NSBundle.mainBundle().bundleIdentifier! + ".", withString: "")
                guard self.products[identifier] != nil else {
                    continue
                }

                // handle transaction
                switch (transaction.transactionState) {
                case .Restored:
                    NSLog("%@: Restored", transaction.payment.productIdentifier)
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)

                    self.trigger(EventType.ProductWasRestored, identifier)
                    self.trigger(EventType.InteractionEnded)
                    break

                case .Purchasing:
                    NSLog("%@: Purchasing", transaction.payment.productIdentifier)
                    break

                case .Purchased:
                    NSLog("%@: Purchased", transaction.payment.productIdentifier)
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)

                    self.trigger(EventType.ProductWasBuyed, identifier)
                    self.trigger(EventType.InteractionEnded)
                    break

                case .Failed:
                    NSLog("%@: Failed", transaction.payment.productIdentifier)
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction)

                    self.trigger(EventType.InteractionEnded)
                    break

                case .Deferred:
                    NSLog("%@: Deferred", transaction.payment.productIdentifier)
                    break
                }
            }
        #endif
    }

    // restore purchases
    func restoreAll() -> Store {
        self.trigger(EventType.InteractionStarted)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()

        return self
    }

    // restoring
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        #if !STORE_PASSTHROUGH
            for transaction in queue.transactions {
                let identifier = transaction.payment.productIdentifier.stringByReplacingOccurrencesOfString(NSBundle.mainBundle().bundleIdentifier! + ".", withString: "")
                self.trigger(EventType.ProductWasRestored, identifier)
            }

            self.trigger(EventType.InteractionEnded)
        #endif
    }

    // restore failed
    func paymentQueue(queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: NSError) {
        #if !STORE_PASSTHROUGH
            NSLog("Restore failed: %@", error)
            self.trigger(EventType.InteractionEnded)
        #endif
    }
}