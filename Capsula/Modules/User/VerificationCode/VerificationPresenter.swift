//
//  VerificationPresenter.swift
//  Mansour
//
//  Created SherifShokry on 11/25/19.
//  Copyright © 2019 BlueCrunch. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//
import Foundation

class VerificationPresenter : ViewToPresenterVerificationProtocol{
  
    
    
    var view: PresenterToViewVerificationProtocol?
    var interactor: PresenterToIntetractorVerificationProtocol?
    var router: PresenterToRouterVerificationProtocol?
    var signUpRequest = RegisterRequest()
    var phoneNumber = ""
    
    func setPhoneNumber(phone : String){
        self.phoneNumber = phone
    }
    
    func sendVerificationCode() {
        self.view?.changeState(state: .loading)
        self.interactor?.sendVerificationCode(phone: ("+966" + phoneNumber))
    }
    
    func verifyCode(code: String) {
        self.view?.changeState(state: .loading)
        self.interactor?.verifyCode(code: code)
    }
    
}

extension VerificationPresenter : InteractorToPresenterVerificationProtocol {
    func phoneNumberVerified(firebaseToken: String) {
        self.view?.changeState(state: .ready)
        signUpRequest.deviceToken = firebaseToken
      
        if signUpRequest.phone != "" {
           self.view?.changeState(state: .loading)
            if signUpRequest.password != "" {
                //Register
                self.interactor?.register(registerRequest: signUpRequest)
            }else{
                //CompleteProfile
                self.interactor?.completeProfile(registerRequest: signUpRequest)
            }
            
        }else{
            
            self.router?.openForgetPasswordSecondStepScreen(from: self.view, phone: phoneNumber,firebaseToken : firebaseToken)
        }
        
    }
    
    func codeNotValid(error: String) {
        let errorMsg = Strings.Validation.shared.verificationCodeNotValid
        self.view?.changeState(state: .error(errorMsg))
    }
    
    func codeSentSuccessfully() {
        self.view?.changeState(state: .ready)
    }
    
    func codeFailedToSent(error: String) {
        self.view?.changeState(state: .error(error))
    }
    
    
    func userRegisteredSuccessfully() {
        self.view?.changeState(state: .ready)
        self.router?.openAddAddress(from: self.view)
        
    }
    
    func userFailedToRegister(error: String) {
        self.view?.changeState(state: .error(error))
    }
    
    
}

