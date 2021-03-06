//
//  CartDetailsPresenter.swift
//  Capsula
//
//  Created SherifShokry on 4/3/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

class CartDetailsPresenter : ViewToPresenterCartDetailsProtocol{
    
    func validateAddress() {
         self.view?.changeState(state: .loading)
         self.interactor?.validateAddress()
    }
    
    func setPaymentMethod(method: Int) {
    
    }
    
  
    func getDevliveryCost() {
        self.view?.changeState(state: .loading)
        self.interactor?.getDeliveryCost()
    }
    
   
    
    func prepareCheckout(paymentMethod : Int){
         self.view?.changeState(state: .loading)
        //5 for madda payment
         self.interactor?.prepareCheckout(paymentMethodID: paymentMethod)
    }
    
    var view: PresenterToViewCartDetailsProtocol?
    var interactor: PresenterToIntetractorCartDetailsProtocol?
    var router: PresenterToRouterCartDetailsProtocol?
    var checkoutRequest = CheckoutRequest()
    
    func checkout() {
        self.view?.changeState(state: .loading)
        self.interactor?.checkout(request: checkoutRequest)
     }
    
    func checkout(resourcePath : String, paymentMethod : Int) {
           self.view?.changeState(state: .loading)
           checkoutRequest.resourcePath = resourcePath
           checkoutRequest.paymentMethod = paymentMethod
           self.interactor?.checkout(request: checkoutRequest)
        }
     
     func setPreprictionImage(image: String) {
        
        checkoutRequest.prescriptionImage  = image
     }
     
     func setInsuranceImage(image: String) {
        
        checkoutRequest.insuranceNumberImage = image
    }
   
    
     
    
}

extension CartDetailsPresenter : InteractorToPresenterCartDetailsProtocol {
    func checkoutIDFetchedSuccessfully(checkoutID: String,paymentMethodID : Int) {
        self.view?.changeState(state: .ready)
    
        self.view?.openPaymentScreen(checkoutID: checkoutID, paymentMethod: paymentMethodID)
    }
    
    func deliveryCostFetchedSuccessfully(deliveryCost: DeliveryCostResponse) {
          self.view?.changeState(state: .ready)
          self.view?.setDeliveryCost(cost: deliveryCost)
    }
    
    func checkoutDoneSuccessfully() {
        Utils.emptyLocalCart()
        self.view?.changeState(state: .ready)
        self.view?.moveToSuccessScreen()
    }
    
    func checkoutFailed(error: String) {
        self.view?.changeState(state: .error(error))
    }
    
    
    func addressValidatedSuccessfully() {
            self.view?.changeState(state: .ready)
            self.view?.moveToNextScreen()
       }
    
    
 
}

