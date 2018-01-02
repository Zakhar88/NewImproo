//
//  PurchaseManager.swift
//  Improo
//
//  Created by Zakhar Garan on 02.01.18.
//  Copyright © 2018 GaranZZ. All rights reserved.
//

import StoreKit
import Foundation

let fullAccessID = "ImprooFullAccess"

//public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()

class PurchaseManager: NSObject {
    
    static let shared = PurchaseManager()
    fileprivate var productsRequest: SKProductsRequest?

    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    public func buyProVersion(completion: (_ error: String?)->() ) {
        guard SKPaymentQueue.canMakePayments() else {
            completion("Device is not able or allowed to make payments")
            return
        }
    }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    public func requestProducts() {
        let identifiers: Set<String> = [fullAccessID]
        productsRequest = SKProductsRequest(productIdentifiers: identifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    //fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    
//    public func requestProduct(completionHandler: @escaping ProductsRequestCompletionHandler) {
//        productsRequest.cancel()
//        productsRequestCompletionHandler = completionHandler
//
//        productsRequest = SKProductsRequest(productIdentifiers: [])
//        productsRequest.delegate = self
//        productsRequest.start()
//    }
    
}

extension PurchaseManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(response.products)
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
extension PurchaseManager: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            switch (transaction.transactionState) {
//            case .purchased:
//                complete(transaction: transaction)
//                break
//            case .failed:
//                fail(transaction: transaction)
//                break
//            case .restored:
//                restore(transaction: transaction)
//                break
//            case .deferred:
//                break
//            case .purchasing:
//                break
//            }
//        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
//        print("complete...")
//        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
//        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
//        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
//
//        print("restore... \(productIdentifier)")
//        deliverPurchaseNotificationFor(identifier: productIdentifier)
//        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
//        print("fail...")
//        if let transactionError = transaction.error as? NSError {
//            if transactionError.code != SKError.paymentCancelled.rawValue {
//                print("Transaction Error: \(transaction.error?.localizedDescription)")
//            }
//        }
//        
//        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
//        guard let identifier = identifier else { return }
//
//        purchasedProductIdentifiers.insert(identifier)
//        UserDefaults.standard.set(true, forKey: identifier)
//        UserDefaults.standard.synchronize()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: identifier)
    }
}
