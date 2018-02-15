//
//  PurchaseManager.swift
//  Improo
//
//  Created by Zakhar Garan on 02.01.18.
//  Copyright © 2018 GaranZZ. All rights reserved.
//

import StoreKit
import Foundation

let FullAccessID = "ImprooFullAccess"
let PurchaseNotification = "PurchaseNotification"

class PurchaseManager: NSObject {
    
    static let shared = PurchaseManager()
    
    lazy var purchaseButtonTitle: String = { return "Вимкнути рекламу ($\(fullAccessProduct?.price ?? 1.99))" }()
    
    var fullAccessProduct: SKProduct?
    var productsRequest: SKProductsRequest?

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    public func buyProVersion() {
        guard SKPaymentQueue.canMakePayments() else { return }
        let payment = SKPayment(product: fullAccessProduct!)
        SKPaymentQueue.default().add(payment)
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public func requestProducts() {
        let identifiers: Set<String> = [FullAccessID]
        productsRequest = SKProductsRequest(productIdentifiers: identifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
}

extension PurchaseManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first, product.productIdentifier == FullAccessID else {
            return
        }
        fullAccessProduct = product
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
extension PurchaseManager: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
                case .purchased:
                    complete(transaction: transaction)
                    break
                case .failed:
                    fail(transaction: transaction)
                    break
                case .restored:
                    restore(transaction: transaction)
                    break
                case .deferred:
                    break
                case .purchasing:
                    break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        PostPurchaseNotificationFor(transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        PostPurchaseNotificationFor(productIdentifier)
        SKPaymentQueue().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        if (transaction.error! as NSError).code != SKError.paymentCancelled.rawValue, let errorDescription = transaction.error?.localizedDescription {
            PostPurchaseNotificationFor(errorDescription)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func PostPurchaseNotificationFor(_ message: String) {
        if message == FullAccessID {
            UserDefaults.standard.set(true, forKey: FullAccessID)
            UserDefaults.standard.synchronize()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PurchaseNotification), object: message)
    }
}
