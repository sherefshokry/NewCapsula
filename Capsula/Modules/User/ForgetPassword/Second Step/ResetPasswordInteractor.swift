//
//  ResetPasswordInteractor.swift
//  Capsula
//
//  Created SherifShokry on 1/4/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import Moya
class ResetPasswordInteractor : PresenterToIntetractorResetPasswordProtocol {
    
    var presenter: InteractorToPresenterResetPasswordProtocol?
    private let provider = MoyaProvider<UserDataSource>()
    private let deliveryProvider = MoyaProvider<DeliveryManRegistrationDataSource>()
    
    
    func resetPassword(phone: String,password : String,firebaseToken : String) {
       
           provider.request(.resetPassword(phone, password,firebaseToken)) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(_):
                   self.presenter?.passwordUpdatedSuccessfully()
               case .failure(let error):
                   do{
                       if let body = try error.response?.mapJSON(){
                           let errorData = (body as! [String:Any])
                           self.presenter?.passwordFailedToUpdate(error: (errorData["errors"] as? String) ?? "")
                       }
                   }catch{
                       self.presenter?.passwordFailedToUpdate(error: error.localizedDescription)
                   }
               }
           }
       }
    
    
    func resetDeliveryPassword(phone: String,password : String,firebaseToken : String) {
         
             deliveryProvider.request(.resetPassword(phone, password,firebaseToken)) { [weak self] result in
                 guard let self = self else { return }
                 switch result {
                 case .success(_):
                     self.presenter?.passwordUpdatedSuccessfully()
                 case .failure(let error):
                     do{
                         if let body = try error.response?.mapJSON(){
                             let errorData = (body as! [String:Any])
                             self.presenter?.passwordFailedToUpdate(error: (errorData["errors"] as? String) ?? "")
                         }
                     }catch{
                         self.presenter?.passwordFailedToUpdate(error: error.localizedDescription)
                     }
                 }
             }
         }
    
    
}

