//
//  RegisterInteractor.swift
//  Capsula
//
//  Created SherifShokry on 12/25/19.
//  Copyright © 2019 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//
import UIKit
import Moya

class RegisterInteractor : PresenterToIntetractorRegisterProtocol {
   
    var presenter: InteractorToPresenterRegisterProtocol?
    
    private let provider = MoyaProvider<UserDataSource>()
       
    
    func checkIfPhoneExist(phone: String,email : String) {
           provider.request(.checkPhoneIsExist(phone,email)) { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(_):
                   self.presenter?.phoneIsExist()
               case .failure(let error):
                   self.presenter?.phoneNotExist()
               }
           }
       }
       
    
    
}

