//
//  CartDetailsInteractor.swift
//  Capsula
//
//  Created SherifShokry on 4/3/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Moya
class CartDetailsInteractor : PresenterToIntetractorCartDetailsProtocol {
   
    
  
    
    
    
    
    var presenter: InteractorToPresenterCartDetailsProtocol?
    private let provider = MoyaProvider<CheckOutDataSource>()
    
    func checkout(request: CheckoutRequest) {
        
        provider.request(.checkout(request)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.presenter?.checkoutDoneSuccessfully()
            case .failure(let error):
                do{
                    if let body = try error.response?.mapJSON(){
                        let errorData = (body as! [String:Any])
                        self.presenter?.checkoutFailed(error: (errorData["errors"] as? String) ?? "")
                    }
                }catch{
                    self.presenter?.checkoutFailed(error: error.localizedDescription)
                }
            }
        }
    }
    
    
    
    func getDeliveryCost() {
        provider.request(.getDeliveryCost) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let deliveryCostResponse = try response.map(BaseResponse<DeliveryCostResponse>.self)
                    self.presenter?.deliveryCostFetchedSuccessfully(deliveryCost: deliveryCostResponse.data ?? DeliveryCostResponse() )
                } catch(let catchError) {
                    self.presenter?.checkoutFailed(error: catchError.localizedDescription)
                }
            case .failure(let error):
                do{
                    if let body = try error.response?.mapJSON(){
                        let errorData = (body as! [String:Any])
                        self.presenter?.checkoutFailed(error: (errorData["errors"] as? String) ?? "")
                    }
                }catch{
                    self.presenter?.checkoutFailed(error: error.localizedDescription)
                }
            }
        }
        
    }
    
    
    func prepareCheckout(paymentMethodID: Int) {
          provider.request(.prepareCheckout(paymentMethodID)) { [weak self] result in
                     guard let self = self else { return }
                     switch result {
                     case .success(let response):
                         do {
                             let checkoutIDResponse = try response.map(BaseResponse<String>.self)
                            self.presenter?.checkoutIDFetchedSuccessfully(checkoutID: checkoutIDResponse.data ?? "" ,paymentMethodID : paymentMethodID)
                         } catch(let catchError) {
                             self.presenter?.checkoutFailed(error: catchError.localizedDescription)
                         }
                     case .failure(let error):
                        
                        
                         do{
                             if let body = try error.response?.mapJSON(){
                                 let errorData = (body as! [String:Any])
                                 self.presenter?.checkoutFailed(error: (errorData["errors"] as? String) ?? "")
                             }
                         }catch{
                             self.presenter?.checkoutFailed(error: error.localizedDescription)
                         }
                     }
                 }
      }
    
    
    
    func validateAddress() {
        provider.request(.validateAddress) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.presenter?.addressValidatedSuccessfully()
            case .failure(let error):
                do{
                    if let body = try error.response?.mapJSON(){
                        let errorData = (body as! [String:Any])
                        self.presenter?.checkoutFailed(error: (errorData["errors"] as? String) ?? "")
                    }
                }catch{
                    self.presenter?.checkoutFailed(error: error.localizedDescription)
                }
            }
        }
        
    }
    
    
    
}

