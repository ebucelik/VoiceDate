//
//  IAPPService.swift
//  Casen
//
//  Created by Ebu Bekir Celik on 09.07.19.
//  Copyright © 2019 KeepEasy. All rights reserved.
//

import Foundation
import StoreKit
import Firebase

class IAPService: NSObject{
    
    private override init() {}
    static let shared = IAPService()
    let dating = DatingController()
    var messagesPurchasing = Bool()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts(){
        let products: Set = [IAPProduct.consumable.rawValue, IAPProduct.messagesConsumable.rawValue]
        
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct){
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else{
            return
        }
        
        if product == .messagesConsumable{
            self.messagesPurchasing = true
        }else{
            self.messagesPurchasing = false
        }
        
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restoresPurchases(){
        paymentQueue.restoreCompletedTransactions()
    }
}

extension IAPService: SKProductsRequestDelegate{
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
}

extension IAPService: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        //Wenn mehrere Likes gekauft wurden und nicht richtig abgeschlossen wurden, dann einmal den unteren Code rennen lassen. Wenn die App abstürzt dann war alles richtig.
        //Danach wieder auskommentieren.
        //let queue = SKPaymentQueue.default(); queue.transactions.forEach { queue.finishTransaction($0) }
        for transaction in transactions {
            print(transaction.transactionState.status())
            switch transaction.transactionState{
            case .failed:
                if(UIApplication.shared.isIgnoringInteractionEvents){
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            case .purchasing:
                UIApplication.shared.beginIgnoringInteractionEvents()
                break
            case .purchased:
                if !self.messagesPurchasing{
                    AppDelegate.LIKESCOUNTER = 0

                    DatingController.checkIfNoUser = true
                    DatingController.lastLikedTime = 0
                    
                    var ref: DatabaseReference
                    ref = Database.database().reference()
                    ref.child("Likeable").child(DatingController.finalUserID).child("LikesCounter").setValue(AppDelegate.LIKESCOUNTER)
                    ref.child("Likeable").child(DatingController.finalUserID).child("LastedLikeTime").setValue(DatingController.lastLikedTime)
                }else{
                    ChatViewController.sendenMessagesCounter = 0
                    ChatViewController.maxSendedMessage = 5
                    
                    var ref: DatabaseReference
                    ref = Database.database().reference()
                    ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("buyCompleted").setValue(5)
                    ref.child("Chats").child(ChatViewController.finalUserUid!).child(ChatViewController.userOppositeID).child("sendCounter").setValue(ChatViewController.sendenMessagesCounter)
                }
                
                if(UIApplication.shared.isIgnoringInteractionEvents){
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState{
    func status() -> String{
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}

enum IAPProduct: String {
    case consumable = "KeepEasy.Casen.Likes"
    case messagesConsumable = "KeepEasy.Casen.Messages"
}
